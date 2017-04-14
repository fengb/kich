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

function eexec {
  command -v "$1" &>/dev/null && exec "$@"
}

function watch {
  eexec fswatch --recursive --event-flags --exclude='\.link/.*' --event-flag-separator=, "$KICH_SRC"
}

function notify {
  eexec osascript -e "display notification \"${1-???}\" with title \"kich\""
}

function process {
  while read -r line; do
    [ -z "$line" ] && continue

    file="${line% *}"
    flags="${line##* }"

    [[ "$flags" == *"IsSymLink"* ]] && continue
    [[ "$flags" == *"IsDir"* && "$file" != *".link" ]] && continue

    tgt="`to_tgt <<<"$file"`"
    if [ -e "$file" ]; then
      notify "⇋  $tgt"
    else
      notify "✗  $tgt"
    fi
  done
}

# TODO: proactively handle broken pipe (when 'process' dies)
while true; do
  run_install
  watch | process
  reap
done
