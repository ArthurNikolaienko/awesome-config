#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}
run lxqt-policykit-agent
run picom --experimental-backends -b --config ~/.config/awesome/picom.conf
run skypeforlinux
run keepassxc

run setxkbmap -layout "us,ru,ua" -option "grp:alt_shift_toggle"
run copyq
run nitrogen --restore
