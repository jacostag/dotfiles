#!/bin/bash

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
    - Preview shows: Current working directory, workspace, and window title
    - Selection activates the chosen tab

EXAMPLES:
    $0                  # Launch interactive tab selector
    $0 -s title         # Sort by tab title
    $0 -s cwd -r        # Sort by directory, reverse order
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

# Check if fzf is available
if ! command -v fzf &>/dev/null; then
  echo "Error: fzf is not installed or not in PATH" >&2
  echo "Please install fzf to use this script" >&2
  exit 1
fi

# Get wezterm tab data
tab_data=$(wezterm cli list --format json 2>/dev/null | /usr/bin/jq -r '.[] | "\(.tab_id)|\(.tab_title)|\(.cwd)|\(.workspace)|\(.window_title // "N/A")"' 2>/dev/null)

# Check if wezterm command was successful
if [ $? -ne 0 ] || [ -z "$tab_data" ]; then
  echo "Error: Failed to get wezterm tab information." >&2
  echo "Make sure wezterm is running and accessible." >&2
  exit 1
fi

# Sort the data based on the specified field
sort_column=1
case $sort_field in
id) sort_column=1 ;;
title) sort_column=2 ;;
cwd) sort_column=3 ;;
esac

if [ "$reverse_sort" = true ]; then
  sorted_data=$(echo "$tab_data" | sort -t'|' -k${sort_column} -r)
else
  sorted_data=$(echo "$tab_data" | sort -t'|' -k${sort_column})
fi

# Prepare data for fzf: format as "ID: Title [Workspace]" for display
fzf_input=$(echo "$sorted_data" | awk -F'|' '{
    workspace = ($4 != "" && $4 != "null") ? $4 : "default"
    window_title = ($5 != "" && $5 != "null" && $5 != "N/A") ? $5 : "N/A"
    printf "%s: %s [%s] (%s)|%s|%s|%s\n", $1, $2, workspace, window_title, $3, workspace, window_title
}')

# Use fzf to select a tab
selected=$(echo "$fzf_input" | fzf \
  --prompt="Select tab: " \
  --height=60% \
  --reverse \
  --border=rounded \
  --margin=5% \
  --padding=1 \
  --delimiter='|' \
  --with-nth=1 \
  --preview='echo "Current Directory: {2}" && echo "Workspace: {3}" && echo "Window Title: {4}"' \
  --preview-window=up:4:wrap \
  --header="Up/Down: navigate, Enter: select tab, Esc: cancel" \
  --color='bg:#1e1e2e,bg+:#313244,border:#89b4fa,header:#f38ba8,prompt:#cba6f7')

# If a tab was selected, activate it
if [ -n "$selected" ]; then
  # Extract tab ID from the selected line (format: "ID: Title|cwd")
  tab_id=$(echo "$selected" | awk -F'[:|]' '{print $1}')

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
