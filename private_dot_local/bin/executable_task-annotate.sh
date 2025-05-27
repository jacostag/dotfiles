#!/usr/bin/env bash

set -e

task add +nvim "$@"
ID=$(task +LATEST ids)
task "$ID" annotate "$@"
