{
  pkgs,
  refind-theme-catppuccin,
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
  boot.postBootCommands = ''
    DEVMGR="/dev/nvme0n1"

    efibootmgr --create \
      --disk "$DEVMGR" --part 1 \
      --loader /EFI/refind/refind_x64.efi \
      --label "rEFInd" \
      --unicode
  '';
  system.activationScripts.installManualRefind = {
    text = ''
      mkdir -p /boot/EFI/refind/drivers_x64
      mkdir /boot/EFI/refind/themes
      mkdir /boot/EFI/refind/icons
      mkdir /boot/EFI/refind/fonts
      mkdir /boot/EFI/tools
      mkdir /boot/EFI/Linux

      cp ${pkgs.refind}/share/refind/refind_x64.efi /boot/EFI/refind/refind_x64.efi

      cp -r ${pkgs.refind}/share/refind/drivers_x64/* /boot/EFI/refind/drivers_x64/
      cp -r ${pkgs.refind}/share/refind/themes/* /boot/EFI/refind/themes/
      cp -r ${pkgs.refind}/share/refind/icons/* /boot/EFI/refind/icons/
      cp -r ${pkgs.refind}/share/refind/fonts/* /boot/EFI/refind/fonts/

      cp ${pkgs.memtest86-efi}/BOOTX64.efi /boot/EFI/tools/memtest86.efi
      cp ${pkgs.fwupd-efi}/libexec/fwupd/efi/fwupdx64.efi /boot/EFI/tools/fwupx64.efi
      cp -r ${pkgs.refind-theme-catppuccin} /boot/EFI/refind/themes/catppuccin/
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
          icon /EFI/refind/icons/os_arch.png
          loader /EFI/Linux/nixos.efi
          ostype "Linux"
          submenuentry "Single User" {
            loader /EFI/Linux/arch-linux-single.efi
          }
          submenuentry "Multi User" {
            loader /EFI/Linux/arch-linux-multi.efi
          }
        }
      EOF
    '';
    deps = [ "installManualRefind" ];
  };
}
