#!/usr/bin/env bash
set -eu

SUNXICONFIG="sunxiconfig"
#QCOMCONFIG="qcomconfig"

runbuild() {
    local PC=$1
    nix build -L ".#packages.aarch64-linux.${PC}" --no-link --print-out-paths
}

if res=$(runbuild $SUNXICONFIG); then
    cat "$res" >"kernel/sunxi/config.aarch64-linux.nix"
else
    exit 1
fi

#if res=$(runbuild $QCOMCONFIG); then
#    cat "$res" >"kernel/sdm845/config.aarch64-linux.nix"
#else
#    exit 1
#fi
