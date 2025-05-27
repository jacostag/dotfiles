#!/usr/bin/env bash

# Default task command, returning a count of 'ready' tasks
task_cmd="/usr/bin/task count rc.verbose: +READY"

if [ $(${task_cmd} +TODAY) -gt "0" ]; then
  # Tasks due today
  echo -e " 󰥌 "
elif [ $(${task_cmd} +TOMORROW) -gt "0" ]; then
  # Tasks due tomorrow
  echo -e " 󰃰 "
elif [ $(${task_cmd} "urgency > 10") -gt "0" ]; then
  # Urgent tasks
  echo " 󰨱 "
elif [ $(${task_cmd} +OVERDUE) -gt "0" ]; then
  # Overdue tasks
  echo -e " 󰯆 "
  #echo -e ""
else
  # A count of all tasks
  ${task_cmd}
fi
