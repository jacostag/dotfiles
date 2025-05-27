#!/usr/bin/env bash

set -e

function check_tasks_pwd() {
  current_dir=$(echo $PWD | sed "s|\/|_|g")
  task_cmd="/usr/bin/task count rc.verbose: tag:${current_dir}"
  if [ $(${task_cmd}) -gt "0" ]; then
    echo "  "
    exit 0
  else
    echo ""
    exit 1
  fi
}

check_tasks_pwd &
