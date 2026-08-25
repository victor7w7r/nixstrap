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
  perSystem = { pkgs, ... }: {
    packages = {
      superlab-toplevel = inputs.self.nixosConfigurations.superlab.config.system.build.toplevel;
      superlab-image = inputs.self.nixosConfigurations.superlab-sdimage.config.system.build.sdImage;
      superlab-mktarball = inputs.self.nixosConfigurations.superlab-tarball.config.system.build.tarball;
      superlab-boot = inputs.self.nixosConfigurations.superlab-tarball.config.system.build.bootFiles;
    };
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
            cockpit
            emulation
            firewall
            games
            #kitty
            #virt
            #libvirt
            #plasma._
            remote
            secrets
            victor7w7r
            root
            tools
            #waydroid
            #xr
          ];

          nixos =
            {
              config,
              lib,
              pkgs,
              self',
              ...
            }:
            {
              networking.hostName = "v7w7r-radxarock5b";

              hardware = {
                firmware = with self'.packages; lib.singleton armbian-firmware;
                deviceTree = {
                  name = "rockchip/rk3588-rock-5b.dtb";
                  overlays =
                    map
                      (dtso: {
                        name = "${inputs.armbian}/patch/kernel/archive/rockchip64-6.18/overlay/rockchip-rk3588-${dtso}";
                        dtsFile = "${inputs.armbian}/patch/kernel/archive/rockchip64-6.18/overlay/rockchip-rk3588-${dtso}.dtso";
                      })
                      [
                        "fanctrl"
                        "sata0"
                        "sata1"
                        "sata2"
                        "hdmirx"
                        "can0-m0"
                        "can0-m1"
                        "can1-m0"
                        "can1-m1"
                        "can2-m0"
                        "can2-m1"
                        "i2c8-m2"
                        "pwm0-m0"
                        "pwm0-m1"
                        "pwm0-m2"
                        "pwm1-m0"
                        "pwm1-m1"
                        "pwm1-m2"
                        "pwm2-m1"
                        "pwm3-m0"
                        "pwm3-m1"
                        "pwm3-m2"
                        "pwm3-m3"
                        "pwm5-m2"
                        "pwm6-m0"
                        "pwm6-m2"
                        "pwm7-m0"
                        "pwm7-m3"
                        "pwm8-m0"
                        "pwm10-m0"
                        "pwm11-m0"
                        "pwm11-m1"
                        "pwm12-m0"
                        "pwm13-m0"
                        "pwm13-m2"
                        "pwm14-m0"
                        "pwm14-m1"
                        "pwm14-m2"
                        "pwm15-m0"
                        "pwm15-m1"
                        "pwm15-m2"
                        "pwm15-m3"
                        "uart1-m1"
                        "uart3-m1"
                        "uart4-m2"
                        "uart6-m1"
                        "uart7-m2"
                        "uart8-m1"
                      ];
                };
              };

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
