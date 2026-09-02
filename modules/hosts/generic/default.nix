{ den, inputs, ... }:
{
  perSystem.packages = {
    generic-x86-toplevel = inputs.self.nixosConfigurations.generic-x86.config.system.build.toplevel;
    generic-x86-cross-toplevel =
      inputs.self.nixosConfigurations.generic-x86-cross.config.system.build.toplevel;
    generic-arm-toplevel = inputs.self.nixosConfigurations.generic-arm.config.system.build.toplevel;
    generic-arm-cross-toplevel =
      inputs.self.nixosConfigurations.generic-arm-cross.config.system.build.toplevel;

    generic-x86-vm = inputs.self.nixosConfigurations.generic-x86.config.microvm.declaredRunner;
    generic-arm-vm = inputs.self.nixosConfigurations.generic-arm.config.microvm.declaredRunner;
    generic-x86-cross-vm =
      inputs.self.nixosConfigurations.generic-x86-cross.config.microvm.declaredRunner;
    generic-arm-cross-vm =
      inputs.self.nixosConfigurations.generic-arm-cross.config.microvm.declaredRunner;
  };

  den = {
    hosts = {
      x86_64-linux.generic-x86.users = {
        #root = { };
        snowflake = { };
      };
      x86_64-linux.generic-arm-cross.users = {
        #root = { };
        snowflake = { };
      };
      aarch64-linux.generic-arm.users.users = {
        #root = { };
        snowflake = { };
      };
      aarch64-linux.generic-x86-cross.users.users = {
        #root = { };
        snowflake = { };
      };
    };

    aspects = {
      generic-x86.includes = with den.aspects; [
        generic.common
        (generic.vm-guest { })
      ];
      generic-arm.includes = with den.aspects; [
        generic.common
        (generic.vm-guest { })
      ];
      generic-x86-cross.includes = with den.aspects; [
        generic.common
        (generic.vm-guest { isCross = true; })
      ];
      generic-arm-cross.includes = with den.aspects; [
        generic.common
        (generic.vm-guest { isCross = true; })
      ];

      generic = {
        includes = with den.aspects; [ generic.common ];
        common = {
          includes = with den.aspects; [
            #generic.disks

            cli._
            dev.mise
            gui._
            misc.comm
            misc.fetch
            zen._

            games
            kitty
            plasma._
            root
            snowflake
          ];

          nixos = { pkgs, host, ... }: {
            nixpkgs.overlays = [ inputs.cachyos-kernel.overlays.pinned ];
            networking.hostName = "v7w7r-generic";
            boot.kernelPackages =
              if (host == "x86_64-linux") then
                pkgs.cachyosKernels.linuxPackages.linux-cachyos-latest-lto
              else
                pkgs.linuxPackages_7_1;
          };
        };
      };
    };
  };
}
