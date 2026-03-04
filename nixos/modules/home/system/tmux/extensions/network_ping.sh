#!/usr/bin/env bash

ping_function() {
  case $(uname -s) in
  Linux | Darwin)
    pingtime=$(ping -c 1 "8.8.8.8" | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
    echo "$pingtime ms"
    ;;
  CYGWIN* | MINGW32* | MSYS* | MINGW*) ;;
  esac
}

ping_function
sleep 5
