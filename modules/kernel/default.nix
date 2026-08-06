{ inputs, ... }:
{
  imports = [ (inputs.den.namespace "kernel" true) ];

  flake-file.inputs = {
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    linux = {
      #Without T2
      url = "github:CachyOS/linux/e698e0fc23e30c56f4b72611c25d56fb5b7d0b8d";
      flake = false;
    };
    linux-config = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };
  };
}
