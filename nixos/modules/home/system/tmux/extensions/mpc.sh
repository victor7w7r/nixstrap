#!/usr/bin/env bash

if ! command -v mpc &>/dev/null; then exit 1; fi
mpc_playback=$(mpc current -f "%artist% - %title%")
echo "${mpc_playback}"
