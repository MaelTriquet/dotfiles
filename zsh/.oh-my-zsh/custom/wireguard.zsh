#!/usr/bin/env zsh

function wg() {
  # If there is no flag, just use the regular wg command
  # If the flag is -d, diconnect
  if [[ "$1" == "-d" ]]; then
    command sudo wg-quick down ~/wg-laptop.conf 2> /dev/null
    command sudo resolvconf -u 2> /dev/null
    command sudo wg-quick down ~/wg-laptop.conf
    return

  else if [[ "$1" == "-c" ]]; then
    command sudo wg-quick up ~/wg-laptop.conf 2> /dev/null
    command sudo resolvconf -u 2> /dev/null
    command sudo wg-quick up ~/wg-laptop.conf
    return

  else
    command sudo /usr/bin/wg "$@"
  fi
  fi
}

