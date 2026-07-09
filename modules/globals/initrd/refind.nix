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
    lib.optionalAttrs isEfi {
      boot.loader = {
        grub.enable = false;
        systemd-boot.enable = false;
        efi = {
          efiSysMountPoint = "/boot/EFI";
          canTouchEfiVariables = true;
        };
      };

      system = {
        boot.loader.id = "refind";
        build.installBootLoader =
          {
            efi = "/boot/EFI";
            mocha = "themes/catppuccin/assets/mocha";
            initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
          }
          |> (
            common:
            with pkgs;
            writeScript "boot-loader" ''
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

              [[ ! -d ${common.efi}/BOOT ]] && mkdir -p ${common.efi}/BOOT

              if [ ! -d ${common.efi}/refind ]; then
                echo "Setup Refind"

                [[ -f ${common.efi}/BOOT/BOOTX64.efi ]] && rm ${common.efi}/BOOT/BOOTX64.efi

                cp -r ${refind}/share/refind ${common.efi}/
                cp ${refind}/share/refind/refind_x64.efi ${common.efi}/BOOT/BOOTX64.efi

                rm -rf ${common.efi}/refind/docs ${common.efi}/refind/refind.conf-sample ${common.efi}/refind/images ${common.efi}/refind/drivers_x64/ext*
                rm -rf ${common.efi}/refind/drivers_x64/hfs_x64.efi
                rm -rf ${common.efi}/refind/drivers_x64/iso9660_x64.efi ${common.efi}/refind/drivers_x64/reiserfs_x64.efi
                mkdir -p ${common.efi}/refind/themes
                cp -r ${inputs.catppuccin-refind} ${common.efi}/refind/themes/catppuccin

                cp ${memtest86-efi}/BOOTX64.efi ${common.efi}/refind/tools_x64/memtest86.efi
                cp ${fwupd-efi}/libexec/fwupd/efi/fwupdx64.efi ${common.efi}/refind/tools_x64/fwupx64.efi

                if [ ! -d ${common.efi}/tools ]; then
                 mv ${common.efi}/refind/tools_x64 ${common.efi}/tools
                 cp ${edk2-uefi-shell}/shell.efi ${common.efi}/tools/shellx64.efi
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

              [[ -f ${common.efi}/vmlinuz ]] && rm ${common.efi}/vmlinuz
              [[ -f ${common.efi}/initrd ]] && rm ${common.efi}/initrd

              cp ${common.initrd} ${common.efi}/initrd
              cp ${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile} ${common.efi}/vmlinuz

              echo "$BASE" >> ${common.efi}/versions.txt
              #cp ${common.initrd} /boot/emergency/initrd_$TOPLEVEL

              cat > ${common.efi}/refind/refind.conf << EOF
                banner ${common.mocha}/background.png
                banner_scale fillscreen
                dont_scan_dirs +,EFI
                enable_touch
                enable_mouse
                icons_dir ${common.mocha}/icons
                hideui hwtest,arrows,badges
                scanfor manual,external,internal
                showtools shell, memtest, bootorder, apple_recovery, windows_recovery
                dont_scan_dirs ESP:/EFI/BOOT,EFI/refind,EFI/tools,emergency
                selection_big ${common.mocha}/selection_big.png
                selection_small ${common.mocha}/selection_small.png
                timeout 2
                use_nvram false

                menuentry "NixOS" {
                  icon /EFI/refind/${common.mocha}/icons/os_nixos.png
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
                  sbctl sign -s ${common.efi}/refind/refind_x64.efi &> /dev/null
                  sbctl sign -s ${common.efi}/tools/shellx64.efi &> /dev/null
                  sbctl sign -s ${common.efi}/tools/memtest86.efi &> /dev/null
                  sbctl sign -s ${common.efi}/tools/fwupx64.efi &> /dev/null
                  sbctl sign -s ${common.efi}/refind/drivers_x64/btrfs_x64.efi &> /dev/null
                  sbctl sign -s ${common.efi}/refind/drivers_x64/ntfs_x64.efi &> /dev/null
                  sbctl sign -s ${common.efi}/vmlinuz
                fi
              ''}
            ''
          );
      };
    };

}
