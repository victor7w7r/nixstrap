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
  #mount /dev/sde1 /mnt && rm -rf /mnt/* && mkdir -p /mnt/boot && tar --zstd -xvf boot.tar.zst -C /mnt/boot --no-same-owner && sync && umount /dev/sde1 && udisksctl power-off -b /dev/sde
  #mount -o noatime,nodiratime,lazytime,logbufs=8,logbsize=256k /dev/sde2 /mnt && rm -rf /mnt/* && tar --zstd -xvf store.tar.zst -C /mnt/ && sync && umount /dev/sde2 && udisksctl power-off -b /dev/sde
  den = {
    hosts.aarch64-linux = {
      pizero.users.victor7w7r = { };
      pizero-sdimage.users.victor7w7r = { };
      pizero-tarball.users.victor7w7r = { };
    };

    aspects = {
      pizero-sdimage = {
        #nix build -L ".#nixosConfigurations.pizero-sdimage.config.system.build.sdImage"
        includes = with den.aspects; [
          pizero.common
          (sdcard.lib.call { })
        ];
      };
      pizero-tarball = {
        #nix build -L ".#nixosConfigurations.pizero-tarball.config.system.build.tarball"
        #nix build -L ".#nixosConfigurations.pizero-tarball.config.system.build.bootFiles"
        includes = with den.aspects; [
          pizero.common
          (tarball.lib.call { })
        ];
      };
      pizero = {
        #nix build -L ".#nixosConfigurations.pizero.config.system.build.toplevel"
        includes = with den.aspects; [ pizero.common ];
        common = {
          includes = with den.aspects; [
            (hosts.lib.zram { })
            #(hosts.lib.static-network "enp4s0" "6")
            pizero._

            cli._
            dev.mise
            dev.tools
            dev.ccache
            misc.comm
            misc.fetch
            pentest._

            cockpit
            virt
            secrets
            victor7w7r
          ];

          nixos =
            { lib, pkgs, ... }:
            {
              services = {
                chrony.enable = lib.mkForce false;
                displayManager.ly.enable = lib.mkForce false;
                fail2ban.enable = lib.mkForce false;
              };
              system.autoUpgrade.enable = lib.mkForce false;
              networking.hostName = "v7w7r-opizero2w";
              systemd.tmpfiles.rules = [ "L+ /lib/firmware - - - - /run/current-system/firmware" ];
              boot = {
                kernelParams = [
                  "earlycon"
                  "earlycon=uart,mmio32,0x05000000"
                  "console=ttyS0,115200"
                  "ignore_loglevel"
                  "systemd.bpf_restrict_fs=0"
                  "rd.shell"
                  "rd.retry=10"
                  "systemd.debug_shell=1"
                  "zram.num_devices=2"
                  "page_poison=1"
                  "oops=panic"
                  "randomize_kstack_offset=on"
                ];
                initrd.kernelModules = [
                  #"g_ether"
                  "fido2"
                  "uas"
                  "sunxi_gmac"
                  "sunxi_rsb"
                  "gpio_sunxi"
                  "8250_dw"
                  "zram"
                ];
                initrd.systemd.tpm2.enable = false;
                kernelPackages = (kernel.hosts.pizero pkgs).pizero-kernelPackages;
                loader = {
                  grub.enable = false;
                  generic-extlinux-compatible.enable = true;
                };
              };
            };
        };
      };
    };
  };
}
