{ inputs, ... }:
{
  imports = [ (inputs.den.namespace "kernel" true) ];

  flake-file.inputs = {
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    linux = {
      #Without T2
      url = "github:CachyOS/linux/cachyos-7.1.6-1";
      flake = false;
    };
    linux-config = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };
  };
}
