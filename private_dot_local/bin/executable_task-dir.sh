#!/usr/bin/env bash

# This script checks tasks matching specific criteria:
# - Description starts with '/'
# - Has more than 1 annotation (per user filter 'annotations.count.gt:1')
# It then checks if any *unique* annotation of these tasks is a directory path
# matching the target directory ($PWD by default, or a provided argument).
# If a match is found, it prints "".

function display_custom_task_indicator_with_param() {
  # 0. Prerequisites: Silently exit if 'task' or 'jq' command isn't installed.
  if ! command -v task &>/dev/null; then exit 1; fi
  if ! command -v jq &>/dev/null; then exit 1; fi
  if ! command -v readlink &>/dev/null; then exit 1; fi # For readlink -f

  local target_dir_to_compare # This will hold the canonical path for comparison

  # 1. Determine and validate the target directory
  if [[ $# -eq 0 ]]; then
    # No argument provided, use the current working directory
    if ! target_dir_to_compare=$(readlink -f -- "$PWD"); then
      exit 1 # Failed to resolve PWD (unlikely)
    fi
  elif [[ $# -eq 1 ]]; then
    local input_path="$1"
    # Check if the provided argument is an existing directory
    if [[ ! -d "$input_path" ]]; then
      exit 1 # Not a directory, or does not exist; exit silently
    fi
    # Convert provided path to its canonical form
    if ! target_dir_to_compare=$(readlink -f -- "$input_path"); then
      exit 1 # Failed to resolve the input path
    fi
  else
    # Incorrect number of arguments, exit silently.
    exit 1
  fi

  local found_match=false

  # 2. Define the Taskwarrior filter arguments based on user specification.
  local task_filter_args=('desc.left:/' 'annotations.any:' 'annotations.count.gt:1')

  # 3. Export tasks matching the filter. Then, use jq to extract all unique
  #    annotation descriptions from these tasks.
  local annotation_descriptions
  annotation_descriptions=$(task export "${task_filter_args[@]}" 2>/dev/null |
    jq -r '[.[].annotations[]?.description] | unique[]' 2>/dev/null)

  # If no annotation descriptions were retrieved, exit.
  if [[ -z "$annotation_descriptions" ]]; then
    exit 1
  fi

  # 4. Process each unique annotation description line by line.
  while IFS= read -r annotation_desc; do
    if [[ -z "$annotation_desc" ]]; then # Skip empty lines (e.g. if an annotation was null and unique kept it)
      continue
    fi

    # First, check if the annotation_desc string points to an existing directory
    if [[ -d "$annotation_desc" ]]; then
      # If it is a directory, then get its canonical path for comparison
      local canonical_annotation_path
      if ! canonical_annotation_path=$(readlink -f -- "$annotation_desc"); then
        # Failed to resolve this annotation path (e.g., bad symlink), skip it.
        continue
      fi

      # Compare the canonical path of the annotation with the canonical target directory
      if [[ "$canonical_annotation_path" == "$target_dir_to_compare" ]]; then
        echo ""
        found_match=true
        break # A match is found, no need to check further.
      fi
    fi
  done <<<"$annotation_descriptions" # Feed the descriptions to the loop.

  # 5. Exit with status 0 if a match was found, 1 otherwise.
  if $found_match; then
    exit 0
  else
    exit 1
  fi
}

# Call the main function, passing all script arguments "$@" to it.
# The '&' backgrounds the process, suitable for prompt indicators.
display_custom_task_indicator_with_param "$@" &
