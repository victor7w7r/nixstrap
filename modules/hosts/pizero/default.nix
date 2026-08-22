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
  #mount -o noatime,nodiratime,lazytime,logbufs=8,logbsize=256k /dev/sde2 /mnt && rm -rf /mnt/* && tar --zstd -xvf store.tar.zst -C /mnt/ && sync && umount /dev/sde2 && udisksctl power-off -b /dev/sde

  perSystem.packages = {
    pizero-toplevel = inputs.self.nixosConfigurations.pizero.config.system.build.toplevel;
    pizero-image = inputs.self.nixosConfigurations.pizero-sdimage.config.system.build.sdImage;
    pizero-mktarball = inputs.self.nixosConfigurations.pizero-tarball.config.system.build.tarball;
    pizero-boot = inputs.self.nixosConfigurations.pizero-tarball.config.system.build.bootFiles;
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
        common = { user, ... }: {
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

              systemd.tmpfiles.rules = [ "L+ /lib/firmware - - - - /run/current-system/firmware" ];

              hardware = {
                firmware = with self'.packages; lib.singleton armbian-firmware;
                deviceTree.name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
              };

              environment.persistence."/nix/persist".users."${user.name}".directories = [ ".cache/nix" ];

              boot = {
                blacklistedKernelModules = [ "sun8i_ce" ];
                kernelParams = [
                  "console=ttyS0,115200n8"
                  "ignore_loglevel"
                  "systemd.show_status=true"
                  "systemd.log_target=console"
                  "usbcore.autosuspend=-1"
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
