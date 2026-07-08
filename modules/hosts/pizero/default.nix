{
  den,
  initrd-services,
  kernel,
  ...
}:
{
  #nix build -L ".#nixosConfigurations.opizero2w.config.system.build.toplevel"
  #nix build -L ".#nixosConfigurations.opizero2w.config.system.build.sdImage"
  #nix build -L ".#nixosConfigurations.opizero2w.config.system.build.tarball"
  #nix build -L ".#nixosConfigurations.opizero2w.config.system.build.bootFiles"
  #
  #mount /dev/sde1 /mnt && rm -rf /mnt/* && tar --zstd -xvf boot.tar.zst -C /mnt/ --no-same-owner && umount /dev/sde1 && udisksctl power-off -b /dev/sde
  #mount -o noatime,nodiratime,lazytime,logbufs=8,logbsize=256k /dev/sde1 /mnt && rm -rf /mnt/* && tar --zstd -xvf store.tar.zst -C /mnt/ && sync && umount /dev/sde1 && udisksctl power-off -b /dev/sde

  den = {
    hosts.aarch64-linux.pizero.users.victor7w7r = { };

    aspects.pizero = {
      includes = with den.aspects; [
        (initrd-services.lib.zram { })
        pizero.disks
        pizero.passbolt

        cli._
        dev.mise
        dev.tools
        dev.ccache
        misc.comm
        misc.fetch
        pentest._

        cockpit
        libvirt
        secrets
        victor7w7r
      ];

      nixos =
        { pkgs, ... }:
        {
          networking.hostName = "v7w7r-opizero2w";
          systemd.tmpfiles.rules = [ "L+ /lib/firmware - - - - /run/current-system/firmware" ];
          boot = {
            kernelParams = [
              "earlycon"
              "console=ttyS0,115200n8"
            ];
            initrd.kernelModules = [
              "g_ether"
              "sdhci"
              "sdhci_pci"
              "uas"
              "sunxi_gmac"
              "libcomposite"
            ];
            kernelPackages = (kernel.hosts.pizero pkgs).pizero-kernelPackages;
            loader = {
              grub.enable = false;
              generic-extlinux-compatible.enable = true;
            };
          };
        };
    };
  };
}
