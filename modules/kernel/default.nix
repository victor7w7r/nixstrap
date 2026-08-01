{ inputs, ... }:
{
  imports = [ (inputs.den.namespace "kernel" true) ];

  flake-file.inputs = {
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    linux = {
      url = "github:CachyOS/linux/cachyos-7.1.5-1";
      flake = false;
    };
    linux-config = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };
  };
}
