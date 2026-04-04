FROM docker.io/nixos/nix:latest-arm64 AS builder
WORKDIR /build
RUN git clone https://github.com/mobile-nixos/mobile-nixos
#https://github.com/mwlaboratories/mobile-nixos
WORKDIR /build/mobile-nixos
#RUN git checkout sdm845-bleeding-edge
COPY local.nix .
RUN nix-build --argstr device oneplus-fajita -A outputs.android-fastboot-images
CMD cp -r ./result/* /dist/*
