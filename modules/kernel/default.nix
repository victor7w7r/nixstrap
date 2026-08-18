{
  inputs,
  lib,
  kernel-versions,
  ...
}:
{
  imports = [ (inputs.den.namespace "kernel" true) ];

  _module.args = {
    kernel-versions = {
      latest = "7.1.8";
      lts = "6.18.42";
      legacy = "6.1";
    };
    armPkgs = import inputs.nixpkgs { system = "aarch64-linux"; };
    x86Pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    armCrossPkgs = import inputs.nixpkgs {
      localSystem = "x86_64-linux";
      crossSystem = "aarch64-linux";
    };
    x86CrossPkgs = import inputs.nixpkgs {
      localSystem = "aarch64-linux";
      crossSystem = "x86_64-linux";
    };
  };

  flake-file.inputs = {
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    linux-cachyos-latest = {
      url = "github:CachyOS/linux/cachyos-${kernel-versions.latest}-1";
      flake = false;
    };

    linux-cachyos-config = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };

    linux-cachyos-lts = {
      url = "github:CachyOS/linux/cachyos-${kernel-versions.lts}-1";
      flake = false;
    };

    linux-latest = {
      url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major kernel-versions.latest}.x/linux-${kernel-versions.latest}.tar.xz";
      flake = false;
    };

    linux-lts = {
      url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major kernel-versions.lts}.x/linux-${kernel-versions.lts}.tar.xz";
      flake = false;
    };

    linux-rockchip = {
      url = "github:armbian/linux-rockchip";
      flake = false;
    };

    linux-hardened = {
      url = "https://github.com/anthraxx/linux-hardened/releases/download/v${kernel-versions.lts}-hardened1/linux-hardened-v${kernel-versions.lts}-hardened1.patch";
      flake = false;
    };
  };
}
