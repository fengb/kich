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
  eexec fswatch --recursive --one-per-batch --exclude='\.link/.*' "$KICH_SRC"

  # Naive "watch"
  while true; do
    sleep 60
    echo
  done
}

function diff_added {
  sed -e '/^>/!d' -e 's/> //'
}

function diff_removed {
  sed -e '/^</!d' -e 's/< //'
}

function process {
  changes="`diff "$1" "$2"`"

  <<<"$changes" diff_added | while read -r src; do
    tgt="`tgt_from "$src"`"
    if [ ! -e "$tgt" ]; then
      tgtdir="${tgt%/*}"

      mkdir -p "$tgtdir"
      ln -s "$src" "$tgt"
      log "⇋  $tgt"
    else
      log "!  $tgt"
    fi
  done

  <<<"$changes" diff_removed | while read -r src; do
    tgt="`tgt_from "$src"`"
    if [ -L "$tgt" ] && [ "`readlink "$tgt"`" = "$src" ]; then
      rm "$tgt"
      log "✗  $tgt"
    fi
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
  prev_links="`src_links`"

  watch | while read -r; do
    curr_links="`src_links`"
    process <(echo "$prev_links") <(echo "$curr_links")
    prev_links="$curr_links"
  done

  reap
done
