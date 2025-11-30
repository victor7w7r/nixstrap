{
  pkgs,
  inputs,
  config,
  ...
}:
{
  boot.loader = {
    efi = {
      efiSysMountPoint = "/boot/EFI";
      canTouchEfiVariables = true;
    };
    systemd-boot.enable = false;
    grub.enable = false;
  };

  system.activationScripts.installManualRefind = {
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

  system.activationScripts.writeRefindConfig = {
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

  system.activationScripts.cleanupRefind = {
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

}
