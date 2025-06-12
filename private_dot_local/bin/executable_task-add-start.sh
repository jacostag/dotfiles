#!/usr/bin/env bash
# Add a new task and start it immediately

# Exit immediately if a command exits with a non-zero status.
set -e

# Prints an error message to stderr and exits.
#
# @param $1 - The error message to print.
function error_exit() {
  echo "ERROR: $1" >&2
  exit 1
}

function main() {
  if ! command -v task &>/dev/null; then
    error_exit "The 'task' command could not be found. Please ensure Taskwarrior is installed and in your PATH."
  fi

  # Verify that a task description has been provided.
  if [[ $# -eq 0 ]]; then
    error_exit "You must provide a description for the task.
Usage: task-add-start <your task description>"
  fi

  # Add the task and capture the output to get the ID.
  task add "$@"
  local new_id
  new_id=$(task +LATEST ids)
  #start the task
  task "$new_id" start
}

main "$@"
