#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run picom --experimental-backends -b --config ~/.config/awesome/picom.conf