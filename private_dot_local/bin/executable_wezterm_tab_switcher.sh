#!/usr/bin/env bash

# Script to interactively select and switch to wezterm tabs using fzf
# Parses wezterm cli list output in format: tab_id|tab_title|cwd|workspace|window_title

# Function to display help
show_help() {
  cat <<EOF
Usage: $0 [OPTIONS]

Interactive wezterm tab switcher using fzf.

OPTIONS:
    -h, --help          Show this help message
    -s, --sort FIELD    Sort by field: id, title, or cwd (default: id)
    -r, --reverse       Reverse sort order

DESCRIPTION:
    This script displays wezterm tabs in fzf for interactive selection.
    - Main list shows: Tab ID, Title, Workspace, and Window Title
    - Preview shows: Tab information (ID, directory, workspace, window title) and
      the last 20 lines of content from each pane in the tab
    - Selection activates the chosen tab

EXAMPLES:
    $0                  # Launch interactive tab selector
    $0 -s title         # Sort by tab title
    $0 -s cwd -r        # Sort by directory, reverse order

DEPENDENCIES:
    - wezterm (with CLI support)
    - fzf (for interactive selection)
    - jq (for JSON parsing)
    - bat (optional, for syntax highlighting in preview)
EOF
}

# Default options
sort_field="id"
reverse_sort=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --help)
    show_help
    exit 0
    ;;
  -s | --sort)
    if [[ -z "$2" || "$2" =~ ^- ]]; then
      echo "Error: --sort requires a value (id, title, or cwd)" >&2
      exit 1
    fi
    sort_field="$2"
    shift 2
    ;;
  -r | --reverse)
    reverse_sort=true
    shift
    ;;
  *)
    echo "Unknown option: $1" >&2
    echo "Use -h or --help for usage information." >&2
    exit 1
    ;;
  esac
done

# Validate sort field
case $sort_field in
id | title | cwd) ;;
*)
  echo "Error: Invalid sort field '$sort_field'. Use: id, title, or cwd" >&2
  exit 1
  ;;
esac

# Check required dependencies
missing_deps=()

if ! command -v fzf &>/dev/null; then
  missing_deps+=("fzf")
fi

if ! command -v jq &>/dev/null; then
  missing_deps+=("jq")
fi

if ! command -v wezterm &>/dev/null; then
  missing_deps+=("wezterm")
fi

if [[ ${#missing_deps[@]} -gt 0 ]]; then
  echo "Error: Missing required dependencies: ${missing_deps[*]}" >&2
  echo "Please install the missing tools to use this script" >&2
  exit 1
fi

# Check if bat is available for syntax highlighting (optional)
has_bat=false
if command -v bat &>/dev/null; then
  has_bat=true
fi

# Create secure temporary directory
temp_dir=$(mktemp -d -t wezterm_switcher.XXXXXX)
if [[ ! -d "$temp_dir" ]]; then
  echo "Error: Failed to create temporary directory" >&2
  exit 1
fi

# Cleanup function
cleanup() {
  rm -rf "$temp_dir" 2>/dev/null
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Get wezterm tab data - capture exit code properly
if ! tab_data=$(wezterm cli list --format json 2>/dev/null); then
  echo "Error: Failed to get wezterm tab information." >&2
  echo "Make sure wezterm is running and accessible." >&2
  exit 1
fi

# Check if we got valid data
if [[ -z "$tab_data" ]]; then
  echo "Error: No tab data received from wezterm." >&2
  exit 1
fi

# Extract pane information and capture text content
pane_data=""
while IFS= read -r line; do
  tab_id=$(echo "$line" | jq -r '.tab_id')
  
  # Skip tabs without valid numeric tab IDs
  if [[ -z "$tab_id" || "$tab_id" == "null" || ! "$tab_id" =~ ^[0-9]+$ ]]; then
    continue
  fi
  
  tab_title=$(echo "$line" | jq -r '.tab_title')
  cwd=$(echo "$line" | jq -r '.cwd')
  workspace=$(echo "$line" | jq -r '.workspace')
  window_title=$(echo "$line" | jq -r '.window_title // "N/A"')
  window_id=$(echo "$line" | jq -r '.window_id')

  # Extract pane_id from JSON if available
  pane_id=$(echo "$line" | jq -r '.pane_id // empty')

  # Test if we can get text from this pane ID
  pane_file="$temp_dir/pane_$pane_id"
  if [[ -n "$pane_id" ]] && wezterm cli get-text --pane-id "$pane_id" --end-line 40 >"$pane_file" 2>/dev/null; then
    if [[ -s "$pane_file" ]]; then
      # Add to our data structure
      pane_data+="$tab_id|$tab_title|$cwd|$workspace|$window_title|$window_id|$pane_id"$'\n'
    else
      # If no content, still add the tab info without pane data
      pane_data+="$tab_id|$tab_title|$cwd|$workspace|$window_title|$window_id|"$'\n'
    fi
  else
    # If get-text fails, still add the tab info without pane data
    pane_data+="$tab_id|$tab_title|$cwd|$workspace|$window_title|$window_id|"$'\n'
  fi
done <<<"$(echo "$tab_data" | jq -c '.[]')"

# Convert back to the expected format for compatibility with existing sort logic
# Also filter out any tabs without valid numeric IDs
tab_data=$(echo "$pane_data" | awk -F'|' '!seen[$1]++ && $1 ~ /^[0-9]+$/ {print $1 "|" $2 "|" $3 "|" $4 "|" $5}')

# Sort the data based on the specified field
sort_column=1
case $sort_field in
id) sort_column=1 ;;
title) sort_column=2 ;;
cwd) sort_column=3 ;;
esac

if [[ "$reverse_sort" == true ]]; then
  sorted_data=$(echo "$tab_data" | sort -t'|' -k${sort_column} -r)
else
  sorted_data=$(echo "$tab_data" | sort -t'|' -k${sort_column})
fi

# Prepare data for fzf: format as "Tab ID: Title [Workspace]" for display
fzf_input=$(echo "$sorted_data" | awk -F'|' '{
    workspace = ($4 != "" && $4 != "null") ? $4 : "default"
    window_title = ($5 != "" && $5 != "null" && $5 != "N/A") ? $5 : "N/A"
    printf "Tab %s: %s [%s] (%s)|%s|%s|%s\n", $1, $2, workspace, window_title, $3, workspace, window_title
}')

# Create a mapping file for tab-to-panes relationship
tab_pane_map="$temp_dir/tab_panes"
echo "$pane_data" | awk -F'|' '{if($7) print $1 ":" $7}' >"$tab_pane_map"

# Create preview script that shows comprehensive information
preview_script="$temp_dir/preview.sh"
cat >"$preview_script" <<EOF
#!/usr/bin/env bash
display_text="\$1"
cwd="\$2"
workspace="\$3"
window_title="\$4"

# Extract tab_id from display text (format: "Tab 123: Tab Title [workspace] (window)")
tab_id=\$(echo "\$display_text" | sed 's/^Tab //' | awk -F':' '{print \$1}')

echo "=== TAB INFORMATION ==="
echo "Tab ID: \$tab_id"
echo "Directory: \$cwd"
echo "Workspace: \$workspace"
echo "Window Title: \$window_title"
echo ""

# Find panes for this specific tab
pane_ids=\$(grep "^\$tab_id:" "$tab_pane_map" 2>/dev/null | cut -d: -f2)

if [[ -n "\$pane_ids" ]]; then
    echo "=== PANE CONTENT ==="
    while IFS= read -r pane_id; do
        pane_file="$temp_dir/pane_\$pane_id"
        if [[ -n "\$pane_id" && -f "\$pane_file" ]]; then
            echo "--- Pane \$pane_id (lines: \$(wc -l < "\$pane_file" 2>/dev/null || echo 0)) ---"
            if [[ -s "\$pane_file" ]]; then
                # Remove empty lines and control characters, then display
                content=\$(sed 's/\x1b\[[0-9;]*m//g' "\$pane_file" | sed '/^[[:space:]]*$/d' | tail -40)
                if $has_bat; then
                    echo "\$content" | bat -p --color=always
                else
                    echo "\$content"
                fi
            else
                echo "(empty or no content)"
            fi
            echo ""
        fi
    done <<< "\$pane_ids"
else
    echo "No panes found for this tab"
fi
EOF
chmod +x "$preview_script"

# Use fzf to select a tab
selected=$(echo "$fzf_input" | fzf \
  --prompt="Select tab: " \
  --height=90% \
  --reverse \
  --border=rounded \
  --margin=2% \
  --padding=1 \
  --delimiter='|' \
  --with-nth=1 \
  --preview="$preview_script {1} {2} {3} {4}" \
  --preview-window=up:70%:wrap \
  --header="Up/Down: navigate, Enter: select tab, Esc: cancel" \
  --color='bg:#1e1e2e,bg+:#313244,border:#89b4fa,header:#f38ba8,prompt:#cba6f7')

# If a tab was selected, activate it
if [[ -n "$selected" ]]; then
  # Extract tab ID from the selected line (format: "Tab ID: Title [workspace] (window)|cwd|workspace|window_title")
  tab_id=$(echo "$selected" | sed 's/^Tab //' | awk -F':' '{print $1}')

  # Validate tab_id is numeric
  if [[ ! "$tab_id" =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid tab ID extracted: '$tab_id'" >&2
    exit 1
  fi

  # Activate the selected tab
  if wezterm cli activate-tab --tab-id "$tab_id" 2>/dev/null; then
    echo "Switched to tab $tab_id"
  else
    echo "Error: Failed to activate tab $tab_id" >&2
    exit 1
  fi
else
  echo "No tab selected or operation cancelled."
  exit 0
fi
