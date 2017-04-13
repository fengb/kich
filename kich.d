#!/bin/bash

function cleanup {
  [ ! -z "${pid-}" ] && kill "$pid" &>/dev/null
  wait
  exit $?
}

trap cleanup EXIT

while true; do
  read </dev/tty &
  pid="$!"
  wait "$pid"
done
