{ pkgs, refind-theme-catppuccin, ... }:

{
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.refind = {
    maxGenerations = 6;
    enable = true;
    efiInstallAsRemovable = true;
    extraConfig = ''
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
    '';
    additionalFiles = {
      "themes/catppuccin" = refind-theme-catppuccin;
      "EFI/refind/refind_x64.efi" = "${pkgs.refind}/share/refind/refind_x64.efi";
      "EFI/refind/icons" = "${pkgs.refind}/share/refind/icons";
      "EFI/refind/fonts" = "${pkgs.refind}/share/refind/fonts";
      "EFI/refind/drivers_x64" = "${pkgs.refind}/share/refind/drivers_x64";
      "EFI/tools/memtest86.efi" = "${pkgs.memtest86-efi}/libexec/memtest.efi";
      "EFI/tools/fwupx64.efi" = "${pkgs.fwupd}/lib/efi/fwupdx64.efi";
    };
  };

  boot.initrd.compressor = "xz";
  boot.initrd.compressorArgs = [
    "--check=crc32"
    "--lzma2=dict=6MiB"
    "-T0"
  ];
  boot.initrd.availableKernelModules = [
    "i915"
    "ext4"
  ];
  boot.initrd.kernelModules = [ "i915" ];

  boot.initrd.systemd.enable = true;
  boot.initrd.systemd.packages = with pkgs; [
    cryptsetup
    lvm2
    e2fsprogs
    bash
    busybox
    coreutils
  ];

  boot.uki.settings = {
    UKI = {
      Cmdline = "@/etc/kernel/cmdline";
    };
  };
}
