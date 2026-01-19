{
  pkgs,
  inputs,
  config,
  ...
}:
{
  system.boot.loader.id = "refind";
  system.build.installBootLoader = pkgs.writeScript "installBootLoader.sh" ''
    #!${pkgs.bash}/bin/bash

    ${pkgs.coreutils}/bin/mkdir -p /boot/EFI/tools /boot/EFI/BOOT /boot/EFI/refind/themes

    ${pkgs.coreutils}/bin/cp ${pkgs.refind}/share/refind/refind_x64.efi /boot/EFI/refind/refind_x64.efi
    ${pkgs.coreutils}/bin/cp ${pkgs.refind}/share/refind/refind_x64.efi /boot/EFI/BOOT/BOOTX64.efi
    ${pkgs.coreutils}/bin/cp -r ${pkgs.refind}/share/refind/drivers_x64 /boot/EFI/refind/drivers_x64
    ${pkgs.coreutils}/bin/cp -r ${pkgs.refind}/share/refind/icons /boot/EFI/refind/icons
    ${pkgs.coreutils}/bin/cp -r ${pkgs.refind}/share/refind/fonts /boot/EFI/refind/fonts

    ${pkgs.coreutils}/bin/cp ${pkgs.edk2-uefi-shell}/shell.efi /boot/EFI/tools/shellx64.efi
    ${pkgs.coreutils}/bin/cp ${pkgs.memtest86-efi}/BOOTX64.efi /boot/EFI/tools/memtest86.efi
    ${pkgs.coreutils}/bin/cp ${pkgs.fwupd-efi}/libexec/fwupd/efi/fwupdx64.efi /boot/EFI/tools/fwupx64.efi
    ${pkgs.coreutils}/bin/cp -r ${inputs.catppuccin-refind} /boot/EFI/refind/themes/catppuccin

    ${pkgs.coreutils}/bin/cat > /boot/EFI/refind/refind.conf << EOF
      timeout 2
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
        #submenuentry "Single User" {
        #  loader /EFI/single.efi
        #}
        #submenuentry "Multi User" {
        #  loader /EFI/multi.efi
        #}
      }

      menuentry "Windows 11" {
        icon /EFI/refind/themes/catppuccin/assets/mocha/icons/os_win10.png
        loader /EFI/Microsoft/Boot/bootmgfw.efi
        ostype Windows
      }
    EOF

    EFI_INFO=$(${pkgs.util-linux}/bin/lsblk -o NAME,PARTTYPE,PKNAME,PARTTYPENAME,FSTYPE | \
      ${pkgs.gnugrep}/bin/grep -i "EFI" | ${pkgs.gnugrep}/bin/grep -i "vfat" | ${pkgs.coreutils}/bin/head -n1)
    DISK=$(echo "$EFI_INFO" | ${pkgs.gawk}/bin/awk '{print $3}')

    ${pkgs.efibootmgr}/bin/efibootmgr \
      | ${pkgs.gnugrep}/bin/grep -i "rEFind" \
      | ${pkgs.gawk}/bin/awk '{print $1}' \
      | ${pkgs.gnused}/bin/sed 's/Boot//' \
      | ${pkgs.gnused}/bin/sed 's/\*//' \
      | while read entry; do
        ${pkgs.efibootmgr}/bin/efibootmgr -b "$entry" -B &> /dev/null
      done
    ${pkgs.efibootmgr}/bin/efibootmgr --create \
      --disk /dev/$DISK --part 1 \
      --loader /EFI/refind/refind_x64.efi \
      --label "rEFInd" \
      --unicode &> /dev/null

    TOPLEVEL=$1
    BASE=$(${pkgs.coreutils}/bin/basename $TOPLEVEL)
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

    ${pkgs.coreutils}/bin/cp /boot/EFI/nixos.efi /boot/vault/$BASE.efi
    echo "$BASE" > /boot/EFI/nixos.txt

    #if command -v sbctl >/dev/null 2>&1; then
    #  sbctl sign /boot/EFI/nixos.efi || echo "sbctl sign failed"
    #fi
  '';
}
