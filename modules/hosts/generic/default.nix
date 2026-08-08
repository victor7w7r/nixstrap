{
  den,
  disko,
  inputs,
  ...
}:
{
  perSystem.packages.generic-toplevel =
    inputs.self.nixosConfigurations.generic.config.system.build.toplevel;

  den = {
    hosts.x86_64-linux.generic.users.snowflake = { };
    aspects.generic = {
      includes = with den.aspects; [
        generic._

        cli._
        dev.mise
        gui._
        misc.comm
        misc.fetch
        zen._

        kitty
        plasma._
        secrets
      ];

      nixos =
        { pkgs, modulesPath, ... }:
        {
          nixpkgs.overlays = [ inputs.cachyos-kernel.overlays.pinned ];

          networking.hostName = "v7w7r-generic";

          virtualisation.vmVariant.virtualisation.useEFIBoot = true;
          imports = [
            "${modulesPath}/profiles/qemu-guest.nix"
            inputs.disko.nixosModules.disko
          ];

          boot.kernelPackages = pkgs.cachyosKernels.linuxPackages.linux-cachyos-latest-lto;

          disko.devices.disk = with disko; {
            root = disk.root { };
            main = disk.gpt {
              device = "vda";
              partitions = {
                esp = esp.call { };
                system = btrfs.call {
                  name = "system";
                  size = "100%";
                  priority = 2;
                  subvolumes = disko.btrfs.subvolumes { hasEtc = true; };
                };
              };
            };
          };
        };
    };
  };
}
