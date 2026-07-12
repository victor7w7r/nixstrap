{ inputs, ... }:
{
  flake-file.inputs.catppuccin-refind = {
    url = "github:catppuccin/refind";
    flake = false;
  };

  den.default.nixos =
    {
      config,
      isEfi,
      isTpm,
      lib,
      pkgs,
      ...
    }:
    {
      boot.loader = {
        grub.enable = false;
        systemd-boot.enable = false;
        efi = lib.optionalAttrs isEfi {
          efiSysMountPoint = "/boot/EFI";
          canTouchEfiVariables = true;
        };
      };

      system = lib.optionalAttrs isEfi {
        boot.loader.id = "refind";
        build.installBootLoader =
          with pkgs;
          writeScript "refind-loader" ''
            #!${stdenv.shell}

            export PATH="${
              lib.makeBinPath [
                gnused
                sbctl
                coreutils
                gawk
                util-linux
                efibootmgr
                gnugrep
              ]
            }:$PATH"

            TOPLEVEL=$1

            [[ ! -d /boot/EFI/BOOT ]] && mkdir -p /boot/EFI/BOOT

            if [ ! -d /boot/EFI/refind ]; then
              echo "Setup Refind"

              [[ -f /boot/EFI/BOOT/BOOTX64.efi ]] && rm /boot/EFI/BOOT/BOOTX64.efi

              cp -r ${refind}/share/refind /boot/EFI/
              cp ${refind}/share/refind/refind_x64.efi /boot/EFI/BOOT/BOOTX64.efi

              rm -rf /boot/EFI/refind/docs /boot/EFI/refind/refind.conf-sample /boot/EFI/refind/images /boot/EFI/refind/drivers_x64/ext*
              rm -rf /boot/EFI/refind/drivers_x64/hfs_x64.efi
              rm -rf /boot/EFI/refind/drivers_x64/iso9660_x64.efi /boot/EFI/refind/drivers_x64/reiserfs_x64.efi
              mkdir -p /boot/EFI/refind/themes
              cp -r ${inputs.catppuccin-refind} /boot/EFI/refind/themes/catppuccin

              cp ${memtest86-efi}/BOOTX64.efi /boot/EFI/refind/tools_x64/memtest86.efi
              cp ${fwupd-efi}/libexec/fwupd/efi/fwupdx64.efi /boot/EFI/refind/tools_x64/fwupx64.efi

              if [ ! -d /boot/EFI/tools ]; then
               mv /boot/EFI/refind/tools_x64 /boot/EFI/tools
               cp ${edk2-uefi-shell}/shell.efi /boot/EFI/tools/shellx64.efi
              fi
            fi

            EFI_INFO=$(lsblk -o NAME,PARTTYPE,PKNAME,PARTTYPENAME,FSTYPE \
              | grep -i "EFI" | grep -i "vfat" | head -n1)
            DISK=$(echo "$EFI_INFO" | awk '{print $3}')

            #echo "Setup EFI Entries..."
            #efibootmgr | grep -i "rEFind" | awk '{print $1}' \
            #  | sed 's/Boot//' | sed 's/\*//' \
            #  | while read entry; do efibootmgr -b "$entry" -B &> /dev/null; done

            #efibootmgr --create --disk /dev/$DISK --part 1 \
            #  --loader /EFI/refind/refind_x64.efi --label "rEFInd" \
            #  --unicode &> /dev/null

            [[ -f /boot/EFI/vmlinuz ]] && rm /boot/EFI/vmlinuz
            [[ -f /boot/EFI/initrd ]] && rm /boot/EFI/initrd

            cp $"${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}" /boot/EFI/initrd
            cp ${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile} /boot/EFI/vmlinuz

            echo "$BASE" >> /boot/EFI/versions.txt
            #cp $"${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}" /boot/emergency/initrd_$TOPLEVEL

            cat > /boot/EFI/refind/refind.conf << EOF
              banner themes/catppuccin/assets/mocha/background.png
              banner_scale fillscreen
              dont_scan_dirs +,EFI
              enable_touch
              enable_mouse
              icons_dir themes/catppuccin/assets/mocha/icons
              hideui hwtest,arrows,badges
              scanfor manual,external,internal
              showtools shell, memtest, bootorder, apple_recovery, windows_recovery
              dont_scan_dirs ESP:/EFI/BOOT,EFI/refind,EFI/tools,emergency
              selection_big themes/catppuccin/assets/mocha/selection_big.png
              selection_small themes/catppuccin/assets/mocha/selection_small.png
              timeout 2
              use_nvram false

              menuentry "NixOS" {
                icon /EFI/refind/themes/catppuccin/assets/mocha/icons/os_nixos.png
                loader /EFI/vmlinuz
                initrd /EFI/initrd
                ostype Linux
                options "init=$TOPLEVEL/init ${toString config.boot.kernelParams}"
                submenuentry "Verbose" {
                  add_options "boot.trace=1 systemd.log_level=debug systemd.log_target=console debug udev.log_level=7 rd.systemd.show_status=true"
                }
                submenuentry "Console Only" {
                  add_options "systemd.unit=multi-user.target"
                }
                submenuentry "Rescue" {
                  add_options "systemd.unit=rescue.target boot.shell_on_fail sysrq_always_enabled=0"
                }
              }
            EOF
            ${lib.optionalString isTpm ''
              if [ -d /var/lib/sbctl/keys ]; then
                sbctl sign -s /boot/EFI/refind/refind_x64.efi &> /dev/null
                sbctl sign -s /boot/EFI/tools/shellx64.efi &> /dev/null
                sbctl sign -s /boot/EFI/tools/memtest86.efi &> /dev/null
                sbctl sign -s /boot/EFI/tools/fwupx64.efi &> /dev/null
                sbctl sign -s /boot/EFI/refind/drivers_x64/btrfs_x64.efi &> /dev/null
                sbctl sign -s /boot/EFI/refind/drivers_x64/ntfs_x64.efi &> /dev/null
                sbctl sign -s /boot/EFI/vmlinuz
              fi
            ''}
          '';
      };
    };

}
