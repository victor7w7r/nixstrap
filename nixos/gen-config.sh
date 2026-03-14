#!/usr/bin/env bash
set -eu

cat "$(nix build --extra-experimental-features 'nix-command flakes' -L ".#packages.x86_64-linux.macminiconfig" --no-link --print-out-paths)" \
    >"kernel/generated/macminiconfig.x86_64-linux.nix"

nix-collect-garbage -d

cat "$(nix build --extra-experimental-features 'nix-command flakes' -L ".#packages.x86_64-linux.rogallyconfig" --no-link --print-out-paths)" \
    >"kernel/generated/rogallyconfig.x86_64-linux.nix"

nix-collect-garbage -d

cat "$(nix build --extra-experimental-features 'nix-command flakes' -L ".#packages.x86_64-linux.higoleconfig" --no-link --print-out-paths)" \
    >"kernel/generated/higoleconfig.x86_64-linux.nix"

nix-collect-garbage -d

cat "$(nix build --extra-experimental-features 'nix-command flakes' -L ".#packages.x86_64-linux.serverconfig" --no-link --print-out-paths)" \
    >"kernel/generated/serverconfig.x86_64-linux.nix"
