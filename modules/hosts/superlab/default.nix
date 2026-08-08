{
  den,
  inputs,
  kernel,
  hosts,
  tarball,
  sdcard,
  ...
}:
{
  perSystem.packages = {
    superlab-toplevel = inputs.self.nixosConfigurations.superlab.config.system.build.toplevel;
    superlab-image = inputs.self.nixosConfigurations.superlab.config.system.build.sdImage;
    superlab-tarball = inputs.self.nixosConfigurations.superlab.config.system.build.tarball;
    superlab-boot = inputs.self.nixosConfigurations.superlab.config.system.build.bootFiles;
  };

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
          (sdcard.lib.call {
            nextPartSize = "65536";
            isHDD = false;
            isEntireDisk = true;
          })
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
            (hosts.lib.zram { })
            superlab.disks

            audio._
            cli._
            dev._
            #gui._
            misc.comm
            misc.fetch
            pentest._
            #zen._

            #android
            bluetooth
            cockpit
            #kitty
            #virt
            #libvirt
            #plasma._
            secrets
            victor7w7r
            #waydroid
            #xr
          ];

          nixos =
            { lib, pkgs, ... }:
            {
              networking.hostName = "v7w7r-radxarock5b";
              boot = {
                kernelParams = [
                  "console=ttyS2,1500000n8"
                  "zram.num_devices=2"
                ];
                initrd.kernelModules = [
                  "dw_mmc"
                  "dw_mmc_rockchip"
                  "sdhci_of_dwcmshc"
                  "nvme"
                  "phy_rockchip_naneng_combphy"
                  "fan53555"
                  "rockchip_io_domain"
                  "zram"
                ];
                loader = lib.mkForce {
                  #systemd-boot.enable = true;
                  efi.canTouchEfiVariables = true;
                  generic-extlinux-compatible.enable = true;
                  grub.enable = false;
                };
                kernelPackages = (kernel.hosts.superlab pkgs false).superlab-kernelPackages;
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
