FROM docker.io/nixos/nix:latest-arm64
WORKDIR /build
RUN git clone https://github.com/mobile-nixos/mobile-nixos
WORKDIR /build/mobile-nixos
COPY local.nix .
ENV NIXPKGS_ALLOW_UNFREE=1
ENV NIXPKGS_ALLOW_INSECURE=1

RUN nix-build --argstr device oneplus-fajita -A outputs.android-fastboot-images
CMD cp -r ./result/* /dist/*
