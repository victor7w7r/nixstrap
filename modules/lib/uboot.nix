{ uboot, tauchgang, ... }:
{
  _module.args.uboot = {
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
          CONFIG_USB_KEYBOARD=y
          CONFIG_USB_MUSB_HOST=y
          CONFIG_USB_STAT_MIN=y
          CONFIG_USB_STORAGE=y
          CONFIG_USE_BOOTCOMMAND=y
        '';
      };

      /*setenv boot_targets "usb0"
      setenv bootcmd "usb stop; usb start; bootflow scan -lb"*/

    rock5b =
      pkgs:
      pkgs.ubootRock5ModelB.overrideAttrs (oldAttrs: {
        extraConfig = ''
          CONFIG_AUTOBOOT=y
          CONFIG_AUTOBOOT_KEYED=n
          CONFIG_BOOTCOMMAND="usb stop; usb start; bootflow scan -lb"
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
          uboot.nativeBuildInputs
          ++ [
            buildPackages.stdenv.cc
            buildPackages.pkg-config
            buildPackages.ncurses
            buildPackages.ncurses.dev
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

          export ARCH=arm64
          export CROSS_COMPILE=aarch64-unknown-linux-gnu-

          export PKG_CONFIG_PATH="${pkgs.buildPackages.ncurses.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
          export HOSTCFLAGS="-I${pkgs.buildPackages.ncurses.dev}/include"
          export HOSTLDFLAGS="-L${pkgs.buildPackages.ncurses}/lib -lncurses"

          make defconfig
          make menuconfig
        '';
      };
  };

  perSystem = { pkgs, ... }: {
    devShells = {
      opizero2w-menu-config = uboot.menu-config pkgs.pkgsCross.aarch64-multiplatform (
        uboot.opizero2w pkgs
      );
      rock5b-menu-config = uboot.menu-config pkgs.pkgsCross.aarch64-multiplatform (
        uboot.rock5b pkgs
      );
      fajita-menu-config = uboot.menu-config pkgs.pkgsCross.aarch64-multiplatform (
        uboot.fajita pkgs
      );
      enchilada-menu-config = uboot.menu-config pkgs.pkgsCross.aarch64-multiplatform (
        uboot.enchilada pkgs
      );
    };

    packages = {
      uboot-opizero2w = uboot.opizero2w pkgs.pkgsCross.aarch64-multiplatform;
      uboot-rock5b = uboot.rock5b pkgs.pkgsCross.aarch64-multiplatform;
      uboot-fajita = uboot.fajita pkgs.pkgsCross.aarch64-multiplatform;
      uboot-enchilada = uboot.enchilada pkgs.pkgsCross.aarch64-multiplatform;
    };
  };
}
