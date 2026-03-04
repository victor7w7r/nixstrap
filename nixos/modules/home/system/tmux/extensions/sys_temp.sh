#!/usr/bin/env bash

get_temp() {
  if grep -q "Raspberry" /proc/device-tree/model 2>/dev/null; then
    echo "$(vcgencmd measure_temp | sed 's/temp=//')"
  else
    echo "$(sensors | grep 'TCXC' | awk '{print substr($2, 2)}')"
  fi
}

main() {
  echo "$(get_temp)"
  sleep 5
}

main
