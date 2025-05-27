#!/usr/bin/env bash

set -e

function check_tasks_pwd() {
  current_dir=$PWD
  task_cmd="/usr/bin/task count rc.verbose: pro:${current_dir}"
  if [ $(${task_cmd}) -gt "0" ]; then
    echo "  "
    exit 0
  else
    exit 1
  fi
}

check_tasks_pwd &
