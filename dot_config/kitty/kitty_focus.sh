#!/bin/bash

# Get all tabs, including their ids and focused status
tab_info=$(kitty @ ls | /usr/bin/jq -r '.[].tabs[] | "\(.id)|\(.is_focused)|\(.title)"')

# Filter out the focused tab and prepare the list for fzf
# Format: "last_directory (id: tab_id) | full_path | tab_id"
tab_titles=$(echo "$tab_info" | awk -F'|' '$2 == "false" {
    split($3, path, "/")
    last_dir = path[length(path)]
    if (last_dir == "") last_dir = "/"
    print last_dir " " $1 " | " $3 " | " $1
}')

# Use fzf to fuzzy search the tab titles
selected=$(echo "$tab_titles" | /usr/bin/fzf --prompt="Select tab: " \
  --height=60% \
  --layout=reverse \
  --border=rounded \
  --margin=10%,10% \
  --padding=1 \
  --with-nth=1 \
  --delimiter=' | ' \
  --preview='echo {2}' \
  --preview-window=up:1 \
  --color='bg:237,bg+:235,border:240')

# If a tab was selected, focus on that tab using its ID
if [ -n "$selected" ]; then
  tab_id=$(echo "$selected" | awk -F' \\| ' '{print $3}')
  kitty @ focus-tab --match id:"$tab_id"
else
  echo "No tab selected or operation cancelled."
fi
