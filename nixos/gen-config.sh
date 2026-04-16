#!/usr/bin/env bash
set -eu

MCONFIG="macminiconfig"
ROGCONFIG="rogallyconfig"
HCONFIG="higoleconfig"
SRVCONFIG="serverconfig"

run-build() {
    local PC=$1
    nix build -L ".#packages.x86_64-linux.${PC}" --no-link --print-out-paths
}

if res=$(run-build $SRVCONFIG); then
    cat "$res" >"kernel/generated/${SRVCONFIG}.x86_64-linux.nix"
else
    exit 1
fi

if res=$(run-build $MCONFIG); then
    cat "$res" >"kernel/generated/${MCONFIG}.x86_64-linux.nix"
else
    exit 1
fi

if res=$(run-build $ROGCONFIG); then
    cat "$res" >"kernel/generated/${ROGCONFIG}.x86_64-linux.nix"
else
    exit 1
fi

if res=$(run-build $HCONFIG); then
    cat "$res" >"kernel/generated/${HCONFIG}.x86_64-linux.nix"
else
    exit 1
fi
