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
  exec fswatch -r -x --event-flag-separator : "$KICH_SRC"
}

function process {
  while read -r line; do
    if [ -n "$line" ]; then
      echo "$line"
      echo DONE
    fi
  done
}

# TODO: proactively handle broken pipe (when 'process' dies)
while true; do
  watch | process
  reap
done
