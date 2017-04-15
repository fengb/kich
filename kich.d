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

function run_fswatch {
  fswatch --recursive --event-flags --exclude='\.link/.*' --event-flag-separator=, "$KICH_SRC" | while read -r line; do
    process_fswatch "$line"
  done
}

function process_fswatch {
  line="${1-}"
  [ -z "$line" ] && continue

  file="${line% *}"
  flags="${line##* }"

  [[ "$flags" == *"IsSymLink"* ]] && continue
  [[ "$flags" == *"IsDir"* && "$file" != *".link" ]] && continue

  tgt="`to_tgt <<<"$file"`"
  if [ -e "$file" ]; then
    log "⇋  $tgt"
  else
    log "✗  $tgt"
  fi
}

function run_sleep {
  while true; do
    sleep 60
    yes | run_install | while read -r line; do
      log "$line"
    end
  done
}

function log {
  message="${1-???}"
  echo "kich - $message"
  logger "kich - $message"
  eexec osascript -e "display notification \"$message\" with title \"kich\""
}

# TODO: proactively handle broken pipe (when 'process' dies)
while true; do
  run_install
  if command -v fswatch &>/dev/null; then
    run_fswatch
  else
    run_sleep
  fi
  reap
done
