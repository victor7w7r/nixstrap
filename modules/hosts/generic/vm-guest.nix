{ inputs, ... }:
{
  den.aspects.generic.vm-guest =
    {
      isCross ? false,
    }:
    {
      nixos =
        {
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
            hypervisor = "qemu";
            cpu = if (host.system == "x86_64-linux") then "max" else "cortex-a72";
            qemu.extraArgs = [
              "-M"
              "accel=kvm:tcg,mem-merge=on,sata=off"
            ];
            interfaces = [
              {
                id = "terf-qemu";
                type = "user";
                mac = "02:00:00:00:00:01";
              }
            ];
            shares = [
              {
                source = "downloads";
                mountPoint = "/home/victor7w7r/Descargas";
                tag = "downloads";
                proto = "virtiofs";
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
