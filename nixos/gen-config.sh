#!/usr/bin/env bash
set -eu

cat "$(nix build --extra-experimental-features 'nix-command flakes' ".#packages.x86_64-linux.macminiconfig" --no-link --print-out-paths)" \
    >"kernel/config/macminiconfig.x86_64-linux.nix"

cat "$(nix build --extra-experimental-features 'nix-command flakes' ".#packages.x86_64-linux.rogallyconfig" --no-link --print-out-paths)" \
    >"kernel/config/rogallyconfig.x86_64-linux.nix"

cat "$(nix build --extra-experimental-features 'nix-command flakes' ".#packages.x86_64-linux.higoleconfig" --no-link --print-out-paths)" \
    >"kernel/config/higoleconfig.x86_64-linux.nix"

cat "$(nix build --extra-experimental-features 'nix-command flakes' ".#packages.x86_64-linux.serverconfig" --no-link --print-out-paths)" \
    >"kernel/config/serverconfig.x86_64-linux.nix"
