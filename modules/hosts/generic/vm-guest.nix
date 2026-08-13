{ inputs, ... }:
{
  flake-file.inputs.microvm = {
    url = "github:microvm-nix/microvm.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.generic.vm-guest =
    {
      isCross ? false,
    }:
    {
      nixos =
        {
          pkgs,
          lib,
          host,
          modulesPath,
          ...
        }:
        {
          imports = [
            inputs.microvm.nixosModules.microvm
            "${modulesPath}/virtualisation/qemu-vm.nix"
          ];
          microvm = {
            mem = 8192;
            vcpu = 4;
            kernel = pkgs.linuxPackages_7_1.kernel;
            initrdPath = "${
              (pkgs.nixos {
                imports = [
                  "${pkgs.path}/nixos/modules/profiles/qemu-guest.nix"
                  "${pkgs.path}/nixos/modules/profiles/minimal.nix"
                ];
                boot.kernelPackages = pkgs.linuxPackages_7_1;
              }).config.system.build.initialRamdisk
            }/initrd";
            cpu = if (host.system == "x86_64-linux") then "max" else "cortex-a72";
            qemu.extraArgs = [
              "-M"
              "accel=kvm:tcg,mem-merge=on"
            ];
            interfaces = [
              {
                id = "terf-qemu";
                type = "user";
                mac = "02:00:00:00:00:01";
              }
            ];
            volumes = [
              {
                mountPoint = "/var/lib/qemu";
                image = "generic.img";
                size = 1024 * 20;
              }
            ];
          };
        }
        // (lib.optionalAttrs isCross {
          microvm.cpu = lib.mkForce (if (host.system == "x86_64-linux") then "cortex-a72" else "max");
          nixpkgs = {
            hostPlatform =
              if (host.system == "x86_64-linux") then
                "aarch64-linux"
              else if (host.system == "aarch64-linux") then
                "x86_64-linux"
              else
                host.system;
            buildPlatform = host.system;
          };
        });
    };
}
