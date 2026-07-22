{
  den,
  initrd-services,
  kernel,
  tarball,
  sdcard,
  ...
}:
{
  den = {
    hosts.aarch64-linux = {
      superlab.users.victor7w7r = { };
      superlab-sdimage.users.victor7w7r = { };
      superlab-tarball.users.victor7w7r = { };
    };

    aspects = {
      superlab-sdimage = {
        #nix build -L ".#nixosConfigurations.superlab-sdimage.config.system.build.sdImage"
        #nix build -L ".#nixosConfigurations.superlab-sdimage.config.system.build.bootFiles"
        includes = with den.aspects; [
          superlab.common
          (sdcard.lib.call { ubootSelector = "rockchip"; })
        ];
      };
      superlab-tarball = {
        #nix build -L ".#nixosConfigurations.superlab-tarball.config.system.build.tarball"
        includes = with den.aspects; [
          superlab.common
          (tarball.lib.call { })
        ];
      };
      superlab = {
        includes = with den.aspects; [ superlab.common ];
        common = {
          includes = with den.aspects; [
            (initrd-services.lib.zram { })
            superlab.disks

            audio._
            cli._
            dev._
            gui._
            misc.comm
            misc.fetch
            pentest._
            zen._

            android
            bluetooth
            cockpit
            kitty
            libvirt
            plasma._
            secrets
            victor7w7r
            waydroid
            xr
          ];

          nixos =
            { lib, pkgs, ... }:
            {
              networking.hostName = "v7w7r-radxarock5b";
              boot = {
                kernelParams = [ "console=ttyS2,1500000n8" ];
                loader = {
                  systemd-boot.enable = true;
                  efi.canTouchEfiVariables = true;
                  grub.enable = false;
                };
                kernelPackages = (kernel.hosts.superlab pkgs).superlab-kernelPackages;
                #pkgs.ubootRock5ModelB;
                # kernelPackages = kernel.packages;
              };

              zramSwap = {
                enable = true;
                algorithm = "zstd";
                memoryPercent = 20;
                priority = 100;
              };

              hardware = {
                firmware = [ pkgs.armbian-firmware ];
                deviceTree.name = "rockchip/rk3588-rock-5b.dtb";
              };
            };
        };
      };
    };
  };
}
