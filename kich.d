#!/bin/bash

set -u

source ./kich

init

PID="$$"

trap reap EXIT
function reap {
  pkill -P "$PID"
  exit
}

function watch {
  exec fswatch --recursive --event-flags --exclude='\.link/.*' --event-flag-separator=, "$KICH_SRC"
}

function process {
  while read -r line; do
    [ -z "$line" ] && continue

    file="${line% *}"
    flags="${line##* }"

    if [[ "$flags" == *"IsFile"* || ( "$flags" == *"IsDir"* && "$file" == *".link" ) ]]; then
      if [ -e "$file" ]; then
        echo "run_install $file"
      else
        echo "run_delete $file"
      fi
    fi
  done
}

# TODO: proactively handle broken pipe (when 'process' dies)
while true; do
  run_install
  watch | process
  reap
done
