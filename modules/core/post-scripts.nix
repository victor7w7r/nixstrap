{
  pkgs,
  inputs,
  config,
  username,
  ...
}:
{
  system.activationScripts = {
    installManualRefind = {
      text = ''
        mkdir -p /boot/EFI/refind/drivers_x64
        mkdir -p /boot/EFI/refind/themes
        mkdir -p /boot/EFI/refind/icons
        mkdir -p /boot/EFI/refind/fonts
        mkdir -p /boot/EFI/tools
        mkdir -p /boot/EFI/Linux

        cp ${pkgs.refind}/share/refind/refind_x64.efi /boot/EFI/refind/refind_x64.efi

        cp -r ${pkgs.refind}/share/refind/drivers_x64/* /boot/EFI/refind/drivers_x64/
        cp -r ${pkgs.refind}/share/refind/icons/* /boot/EFI/refind/icons/
        cp -r ${pkgs.refind}/share/refind/fonts/* /boot/EFI/refind/fonts/

        cp ${pkgs.edk2-uefi-shell}/shell.efi /boot/EFI/tools/shellx64.efi
        cp ${pkgs.memtest86-efi}/BOOTX64.efi /boot/EFI/tools/memtest86.efi
        cp ${pkgs.fwupd-efi}/libexec/fwupd/efi/fwupdx64.efi /boot/EFI/tools/fwupx64.efi
        cp -r ${inputs.catppuccin-refind} /boot/EFI/refind/themes/catppuccin/
      '';
      deps = [ "specialfs" ];
    };

    writeRefindConfig = {
      text = ''
        cat > /boot/EFI/refind/refind.conf << EOF
          timeout 3
          screensaver 300
          use_nvram false
          showtools shell, memtest, bootorder, apple_recovery, windows_recovery
          enable_touch
          enable_mouse
          hideui hwtest,arrows,badges
          icons_dir themes/catppuccin/assets/mocha/icons
          banner themes/catppuccin/assets/mocha/background.png
          banner_scale fillscreen
          scanfor manual,external
          dont_scan_dirs +,EFI/Linux
          selection_big themes/catppuccin/assets/mocha/selection_big.png
          selection_small themes/catppuccin/assets/mocha/selection_small.png
          dont_scan_files grubx64.efi

          menuentry "NixOS" {
            icon /EFI/refind/themes/catppuccin/assets/mocha/icons/os_nixos.png
            loader /EFI/nixos.efi
            ostype "Linux"
            submenuentry "Single User" {
              loader /EFI/arch-linux-single.efi
            }
            submenuentry "Multi User" {
              loader /EFI/arch-linux-multi.efi
            }
          }
        EOF
      '';
      deps = [ "installManualRefind" ];
    };

    cleanupRefind = {
      text = ''
        ${pkgs.efibootmgr}/bin/efibootmgr \
          | grep -i "rEFind" \
          | ${pkgs.gawk}/bin/awk '{print $1}' \
          | ${pkgs.gnused}/bin/sed 's/Boot//' \
          | ${pkgs.gnused}/bin/sed 's/\*//' \
          | while read entry; do
            ${pkgs.efibootmgr}/bin/efibootmgr -b "$entry" -B &> /dev/null
          done
        ${pkgs.efibootmgr}/bin/efibootmgr --create \
          --disk ${config.setupDisks.maindevice} --part 1 \
          --loader /EFI/refind/refind_x64.efi \
          --label "rEFInd" \
          --unicode &> /dev/null
      '';
      deps = [ "writeRefindConfig" ];
    };

    installUKI = {
      text = ''
        set -euo pipefail
        if [ -L /run/current-system ]; then
          TOPLEVEL=$(readlink -f /run/current-system)
        else
          TOPLEVEL=$(readlink -f /nix/var/nix/profiles/system)
        fi
        echo $TOPLEVEL
        ${pkgs.buildPackages.systemdUkify}/lib/systemd/ukify build \
          --linux="${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}" \
          --initrd="${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}" \
          --cmdline="init=$TOPLEVEL/init ${toString config.boot.kernelParams}" \
          --uname="${config.boot.kernelPackages.kernel.modDirVersion}" \
          --os-release="${config.system.build.etc}/etc/os-release" \
          --output=/boot/EFI/nixos.efi
          #--signtool=systemd-sbsign \
          #--secureboot-private-key /var/lib/sbctl/db/db.key \
          #--secureboot-certificate /var/lib/sbctl/db/db.pem \

        if command -v sbctl >/dev/null 2>&1; then
          sbctl sign /boot/EFI/nixos.efi || echo "sbctl sign failed"
        fi
      '';
      deps = [ "cleanupRefind" ];
    };

    setupHomeCommon = {
      text = ''
        mkdir -p /home/common
        chown -R ${username}:wheel /home/common
      '';
    };
  };
}
