#!/run/current-system/sw/bin/bash

podman run --privileged --rm docker.io/tonistiigi/binfmt --install all
podman run -it --platform linux/arm64 docker.io/nixos/nix:latest-arm64
