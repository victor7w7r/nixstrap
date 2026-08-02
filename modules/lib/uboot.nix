{
  inputs,
  uboot,
  tauchgang,
  ...
}:
{
  imports = [ (inputs.den.namespace "uboot" false) ];

  uboot.lib = {
    enchilada = pkgs: (tauchgang pkgs false);
    fajita = pkgs: (tauchgang pkgs true);
    opizero2w =
      pkgs:
      pkgs.buildUBoot {
        defconfig = "orangepi_zero2w_defconfig";
        extraMeta.platforms = [ "aarch64-linux" ];
        env.BL31 = "${pkgs.pkgsCross.aarch64-multiplatform.armTrustedFirmwareAllwinnerH616}/bl31.bin";
        filesToInstall = [ "u-boot-sunxi-with-spl.bin" ];
        extraConfig = ''
          CONFIG_AUTOBOOT=y
          CONFIG_AUTOBOOT_KEYED=n
          CONFIG_BOOTCOMMAND="usb stop; usb start; run distro_bootcmd"
          CONFIG_BOOTDELAY=3
          CONFIG_BOOTP_SUBNETMASK=n
          CONFIG_BOOTSTD_FULL=y
          CONFIG_BOOT_TARGETS="usb0 mmc0"
          CONFIG_CMD_BOOTFLOW=y
          CONFIG_CMD_DHCP=n
          CONFIG_CMD_PXE=n
          CONFIG_NET=n
          CONFIG_DM_REGULATOR=y
          CONFIG_DM_REGULATOR_FIXED=y
          CONFIG_AXP2101_POWER=y
          CONFIG_PHY_SUN4I_USB=y
          CONFIG_USB_EHCI_HCD=y
          CONFIG_USB_OHCI_HCD=y
          CONFIG_USB_EHCI_SUNXI=y
          CONFIG_USB_OHCI_SUNXI=y
          CONFIG_USB_KEYBOARD=y
          CONFIG_USB_MUSB_HOST=y
          CONFIG_USB_STAT_MIN=y
          CONFIG_USB_STORAGE=y
          CONFIG_USE_BOOTCOMMAND=y
        '';
      };

    rock5b =
      pkgs:
      pkgs.ubootRock5ModelB.overrideAttrs (oldAttrs: {
        extraConfig = ''
          CONFIG_AUTOBOOT=y
          CONFIG_AUTOBOOT_KEYED=n
          CONFIG_BOOTCOMMAND="usb stop; usb start; run distro_bootcmd"
          CONFIG_BOOT_TARGETS="usb0 nvme0 mmc1 mmc0"
          CONFIG_BOOTP_SUBNETMASK=n
          CONFIG_BOOTSTD_FULL=y
          CONFIG_CMD_BOOTFLOW=y
          CONFIG_CMD_DHCP=n
          CONFIG_CMD_PXE=n
          CONFIG_DM_PCI_COMPAT=y
          CONFIG_NET=n
          CONFIG_PHY_ROCKCHIP_NANENG_EDP=y
          CONFIG_PHY_ROCKCHIP_SAMSUNG_HDPTX=y
          CONFIG_PHY_ROCKCHIP_SNPS_PCIE3=y
          CONFIG_USB_KEYBOARD=y
          CONFIG_USB_STAT_MIN=y
          CONFIG_USB_STORAGE=y
          CONFIG_USE_BOOTCOMMAND=y
        '';
      });

    menu-config =
      pkgs: uboot:
      pkgs.mkShell {
        nativeBuildInputs =
          with pkgs;
          kernel.nativeBuildInputs
          ++ [
            ncurses
            pkg-config
            bison
            flex
          ];

        shellHook = ''
          TMP_DIR="/tmp/kconfig-${uboot.name}"
          mkdir -p "$TMP_DIR"
          cd "$TMP_DIR"

          if [ ! -d "src" ]; then
            if [ -d "${uboot.src}" ]; then
              cp -r --no-preserve=mode,ownership "${uboot.src}" src
            else
              mkdir src
              tar -xf "${uboot.src}" -C src --strip-components=1
              chmod -R +w src
            fi

            chmod -R +rwx src
            cd src

          else
            cd src
          fi

          make "ARCH=arm64" defconfig
          make "ARCH=arm64" menuconfig
        '';
      };
  };

  perSystem = { pkgs, ... }: {
    devShells = {
      opizero2w-menu-config = uboot.lib.menu-config pkgs.pkgsCross.aarch64-multiplatform (
        uboot.lib.opizero2w pkgs
      );
      rock5b-menu-config = uboot.lib.menu-config pkgs.pkgsCross.aarch64-multiplatform (
        uboot.lib.rock5b pkgs
      );
      fajita-menu-config = uboot.lib.menu-config pkgs.pkgsCross.aarch64-multiplatform (
        uboot.lib.fajita pkgs
      );
      enchilada-menu-config = uboot.lib.menu-config pkgs.pkgsCross.aarch64-multiplatform (
        uboot.lib.enchilada pkgs
      );
    };

    packages = {
      uboot-opizero2w-menu-config = uboot.lib.opizero2w pkgs;
      rock5b-menu-config = uboot.lib.rock5b pkgs;
      fajita-menu-config = uboot.lib.fajita pkgs;
      enchilada-menu-config = uboot.lib.enchilada pkgs;
    };
  };
}
