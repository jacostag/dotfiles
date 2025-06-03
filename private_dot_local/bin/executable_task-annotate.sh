#!/usr/bin/env bash
# Useful to add to a keymap on nvim to add a task with the editing file as annotation.
# vim.keymap.set(
#   "n",
#   "<leader>ct",
#   "<cmd>!~/.local/bin/task-annotate.sh '%:p' <CR>",
#   { desc = "Add current file to a new taskwarrior task" }
# )

set -e

if ! command -v task &>/dev/null; then
  error_exit "The 'task' command could not be found. Please ensure Taskwarrior is installed and in your PATH."
fi

/usr/bin/task add +nvim "$@"
ID=$(/usr/bin/task +LATEST ids)
/usr/bin/task "$ID" annotate "$@"
