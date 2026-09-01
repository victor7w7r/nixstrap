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
      latest = "7.2.2";
      lts = "6.18.48";
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

    linux-config = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };

    linux-latest = {
      url = "github:CachyOS/linux/cachyos-${kernel-versions.latest}-1";
      flake = false;
    };

    linux-lts = {
      url = "github:CachyOS/linux/cachyos-${kernel-versions.lts}-2";
      flake = false;
    };
  };
}
