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
    superlab-image = inputs.self.nixosConfigurations.superlab-sdimage.config.system.build.sdImage;
    superlab-mktarball = inputs.self.nixosConfigurations.superlab-tarball.config.system.build.tarball;
    superlab-boot = inputs.self.nixosConfigurations.superlab-tarball.config.system.build.bootFiles;
  };

  den = {
    hosts.aarch64-linux = {
      superlab.users = {
        #root = { };
        victor7w7r = { };
      };
      superlab-sdimage.users = {
        #root = { };
        victor7w7r = { };
      };
      superlab-tarball.users = {
        #root = { };
        victor7w7r = { };
      };
    };

    aspects = {
      superlab-sdimage.includes = with den.aspects; [
        superlab.common
        (sdcard.lib.call {
          nextPartSize = "65536";
          isHDD = false;
          isEntireDisk = true;
        })
      ];
      superlab-tarball.includes = with den.aspects; [
        superlab.common
        (tarball.lib.call { })
      ];
      superlab = {
        includes = with den.aspects; [ superlab.common ];
        common = {
          includes = with den.aspects; [
            (hosts.lib.zram {
              value = "4G";
              memoryPercent = 100;
            })
            (hosts.lib.static-network "enP4p65s0" "12")
            superlab.disks

            audio._
            cli._
            dev._
            disks
            #gui._
            misc.comm
            misc.fetch
            pentest._
            #zen._

            #android
            bluetooth
            emulation
            firewall
            games
            #kitty
            #virt
            #libvirt
            #plasma._
            remote
            victor7w7r
            root
            tools
            #waydroid
            #xr
          ];

          nixos =
            {
              lib,
              pkgs,
              self',
              ...
            }:
            {
              networking.hostName = "v7w7r-radxarock5b";

              hardware = {
                firmware = with self'.packages; lib.singleton armbian-firmware;
                deviceTree.name = "rockchip/rk3588-rock-5b.dtb";
              };

              services.udev.extraRules = ''
                KERNEL=="hidraw*", ATTRS{idVendor}=="1050", MODE="0666"
              '';

              boot = {
                kernelParams = [
                  "console=ttyS2,1500000n8"
                  "firmware_class.path=/extra-firmware"
                ];
                loader = {
                  grub.enable = false;
                  generic-extlinux-compatible.enable = true;
                };
                kernelPackages =
                  (kernel.hosts.superlab pkgs "superlab" "aarch64-linux" pkgs.stdenv.hostPlatform.system)
                  .superlab-kernelPackages;
              };
            };
        };
      };
    };
  };
}
