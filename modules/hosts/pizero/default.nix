{
  den,
  inputs,
  hosts,
  kernel,
  tarball,
  sdcard,
  ...
}:
{
  #mount /dev/sde1 /mnt && rm -rf /mnt/* && tar --zstd -xvf boot.tar.zst -C /mnt/ --no-same-owner && sync && umount /dev/sde1 && udisksctl power-off -b /dev/sde
  #mount -o noatime,nodiratime,lazytime,discard=async,compress-force=zstd:3,subvol=@nix /dev/sde2 /mnt && rm -rf /mnt/store/* && tar --zstd -xvf store.tar.zst -C /mnt/store/ && sync && umount /dev/sde2 && udisksctl power-off -b /dev/sde

  perSystem = { pkgs, ... }: {
    packages = {
      pizero-toplevel = inputs.self.nixosConfigurations.pizero.config.system.build.toplevel;
      pizero-image = inputs.self.nixosConfigurations.pizero-sdimage.config.system.build.sdImage;
      pizero-mktarball = inputs.self.nixosConfigurations.pizero-tarball.config.system.build.tarball;
      pizero-boot = inputs.self.nixosConfigurations.pizero-tarball.config.system.build.bootFiles;
    };
  };

  den = {
    hosts.aarch64-linux = {
      pizero.users = {
        #root = { };
        victor7w7r = { };
      };
      pizero-sdimage.users = {
        #root = { };
        victor7w7r = { };
      };
      pizero-tarball.users = {
        #root = { };
        victor7w7r = { };
      };
    };

    aspects = {
      pizero-sdimage.includes = with den.aspects; [
        pizero.common
        (sdcard.lib.call { })
      ];
      pizero-tarball.includes = with den.aspects; [
        pizero.common
        (tarball.lib.call { })
      ];
      pizero = {
        includes = with den.aspects; [ pizero.common ];
        common = {
          includes = with den.aspects; [
            (hosts.lib.zram {
              value = "256M";
              memoryPercent = 100;
            })
            (hosts.lib.static-network "enp4s0" "14")
            pizero._

            cli._
            dev.mise
            dev.tools
            dev.ccache
            disks
            misc.comm
            misc.fetch
            pentest._

            cockpit
            emulation
            firewall
            games
            remote
            root
            secrets
            tools
            victor7w7r
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
              networking.hostName = "v7w7r-opizero2w";
              environment.persistence."/nix/persist".users = {
                "victor7w7r".directories = [ ".cache" ];
                root.directories = [ ".cache" ];
              };
              systemd.tmpfiles.rules = [ "L+ /lib/firmware - - - - /run/current-system/firmware" ];

              hardware = {
                firmware = with self'.packages; lib.singleton armbian-firmware;
                deviceTree = {
                  name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
                  overlays =
                    map
                      (dtso: {
                        name = "${inputs.armbian}/patch/kernel/archive/sunxi-6.18/overlay_64/sun50i-h616-${dtso}";
                        dtsFile = "${inputs.armbian}/patch/kernel/archive/sunxi-6.18/overlay_64/sun50i-h616-${dtso}.dtso";
                      })
                      [
                        "i2c2-ph"
                        "i2c3-pg"
                        "i2c3-ph"
                        "i2c4-pg"
                        "i2c4-ph"
                        "keys"
                        "pwm1-ph3"
                        "pwm1-pi11"
                        "pwm2-ph2"
                        "pwm2-pi12"
                        "pwm3-ph0"
                        "pwm3-pi13"
                        "uart2-pg"
                        "uart2-pg-rts-cts"
                        "uart2-ph"
                        "uart2-ph-rts-cts"
                        "uart2-pi"
                        "uart2-pi-rts-cts"
                        "uart3-pi"
                        "uart3-pi-rts-cts"
                        "uart4-pi"
                        "uart4-pi-rts-cts"
                        "uart5"
                      ];
                };
              };

              boot = {
                blacklistedKernelModules = [ "sun8i_ce" ];
                kernelParams = [
                  "console=ttyS0,115200n8"
                  "firmware_class.path=/extra-firmware"
                  #"resume=${config.boot.resumeDevice}"
                ];
                loader = {
                  grub.enable = false;
                  generic-extlinux-compatible.enable = true;
                };
                kernelPackages =
                  (kernel.hosts.pizero pkgs "pizero" "aarch64-linux" pkgs.stdenv.hostPlatform.system)
                  .pizero-kernelPackages;
              };

              services = {
                displayManager.ly.enable = lib.mkForce false;
                fail2ban.enable = lib.mkForce false;
              };
              system.autoUpgrade.enable = lib.mkForce false;
            };
        };
      };
    };
  };
}
