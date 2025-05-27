#!/usr/bin/env bash

set -e

current_dir=$(echo $PWD | sed "s|\/|_|g")
/usr/bin/task add tag:${current_dir} "$@"
exit 0
