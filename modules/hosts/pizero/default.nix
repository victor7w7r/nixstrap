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
  #dd if=u-boot-sunxi-with-spl.bin of=/dev/sde bs=1024 seek=8 conv=notrunc
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
            # kernelPackages = kernel.packages;
          };

          zramSwap = {
            enable = true;
            algorithm = "zstd";
            memoryPercent = 100;
            priority = 100;
          };

          hardware.deviceTree = {
            enable = true;
            name = "allwinner/sun50i-h618-orangepi-zero2w.dtb";
          };
        };
    };
  };
}
/*
  let
    #uboot = import ./custom/sunxi-uboot.nix { inherit pkgs; };
    f2fs = import ./lib/f2fs.nix;
    kernel = (pkgs.callPackage ../kernel/sunxi) { inherit kernelData; };
    #cp ${uboot}/u-boot-sunxi-with-spl.bin $out/
  in
  {
    imports = [
        (import ./soc {
        inherit config pkgs host;
        postBuildCommands = "dd if=${uboot}/u-boot-sunxi-with-spl.bin of=boot.img bs=1024 seek=8 conv=notrunc";
        populateFirmwareCommands = ''
          mkdir -p firmware/boot
          ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
            -c ${config.system.build.toplevel} -d firmware/boot
        '';
        })

      (import ./lib/tarball.nix {
        inherit config pkgs;
        additionalContent = bootFiles;
      })
    ];

      pkgs.buildUBoot {
      defconfig = "orangepi_zero2w_defconfig";
      extraMeta.platforms = [ "aarch64-linux" ];
      BL31 = "${pkgs.armTrustedFirmwareAllwinnerH616}/bl31.bin";
      filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
      };

      bootFiles = ''
        mkdir -p boot
        ${config.boot.loader.generic-extlinux-compatible.populateCmd} \
          -c ${config.system.build.toplevel} -d boot
        tar -cv -C . boot | zstd -T$NIX_BUILD_CORES > $out/boot.tar.zst
      '';
      system.build.bootFiles =
        pkgs.runCommand "boot-files" { nativeBuildInputs = with pkgs; [ zstd ]; }
          ''
            mkdir -p $out
            ${bootFiles}
          '';

      };
*/
