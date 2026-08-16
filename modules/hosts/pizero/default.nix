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
        common = {
          includes = with den.aspects; [
            (hosts.lib.zram { })
            #(hosts.lib.static-network "enp4s0" "6")
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
            remote
            root
            secrets
            tools
            victor7w7r
            virt
          ];

          nixos =
            {
              lib,
              pkgs,
              armPkgs,
              ...
            }:
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
                  "console=ttyS0,115200n8"
                  "clk_ignore_unused"
                  "ignore_loglevel"
                  "systemd.show_status=true"
                  "systemd.log_target=console"
                  "oops=panic"
                  "randomize_kstack_offset=on"
                  "boot.shell_on_fail"
                  "rd.shell"
                  "devtmpfs.mount=1"
                ];
                initrd.kernelModules = [
                  "ac200_phy"
                  "ahci"
                  "configfs"
                  "display_connector"
                  "dm_crypt"
                  "dm_mod"
                  "ehci_hcd"
                  "encrypted_keys"
                  "musb_hdrc"
                  "panfrost"
                  "phy_generic"
                  "phy_sun4i_usb"
                  "sprdbt_tty"
                  "sprdwl_ng"
                  "sun50i_h6_prcm_ppu"
                  "sun8i_ce"
                  "sunxi"
                  "sunxi_addr"
                  "uas"
                  "uhci_hcd"
                  "usb_storage"
                  "usbcore"
                  "usbhid"
                  "xhci_hcd"
                  "xhci_pci"
                ];
                initrd.systemd.tpm2.enable = false;
                kernelPackages = (kernel.hosts.pizero pkgs "pizero").pizero-kernelPackages;
                loader = {
                  grub.enable = false;
                  generic-extlinux-compatible.enable = true;
                };
              };
            }
            // (lib.optionalAttrs pkgs.stdenv.buildPlatform.isx86_64 {
              _module.args.pkgs = armPkgs;
            });
        };
      };
    };
  };
}
