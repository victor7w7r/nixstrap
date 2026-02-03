{
  pkgs,
  inputs,
  config,
  ...
}:
let
  efi = "/boot/EFI";
  cat = "${pkgs.coreutils}/bin/cat";
  cp = "${pkgs.coreutils}/bin/cp";
  mkdir = "${pkgs.coreutils}/bin/mkdir";
  refind = "${pkgs.refind}/share/refind";
  awk = "${pkgs.gawk}/bin/awk";
  sbctl = "${pkgs.sbctl}/bin/sbctl";
  edk2 = pkgs.edk2-uefi-shell;
  memtest = pkgs.memtest86-efi;
  head = "${pkgs.coreutils}/bin/head";
  fwupd = "${pkgs.fwupd-efi}/libexec/fwupd/efi";
  grep = "${pkgs.gnugrep}/bin/grep";
  efibootmgr = "${pkgs.efibootmgr}/bin/efibootmgr";
  lsblk = "${pkgs.util-linux}/bin/lsblk";
  sed = "${pkgs.gnused}/bin/sed";
  basename = "${pkgs.coreutils}/bin/basename";
  wget = "${pkgs.wget2}/bin/wget2";
  efifs = "https://github.com/pbatard/EfiFs/releases/download/v1.11";
  icons = "/EFI/refind/themes/catppuccin/assets/mocha/icons";
  kernel = "${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}";
  initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";

  refind-opts = ''
    banner themes/catppuccin/assets/mocha/background.png
    banner_scale fillscreen
    dont_scan_files grubx64.efi
    dont_scan_dirs +,EFI
    enable_touch
    enable_mouse
    icons_dir themes/catppuccin/assets/mocha/icons
    hideui hwtest,arrows,badges
    screensaver 300
    scanfor manual,external
    showtools shell, memtest, bootorder, apple_recovery, windows_recovery
    selection_big themes/catppuccin/assets/mocha/selection_big.png
    selection_small themes/catppuccin/assets/mocha/selection_small.png
    timeout 2
    use_nvram false
  '';

  debugFlags = "boot.trace=1 debug udev.log_level=7 rd.systemd.show_status=true";

  entries = ''
    menuentry "NixOS" {
      icon ${icons}/os_nixos.png
      loader /EFI/kernel
      initrd /EFI/initrd
      options "init=$TOPLEVEL/init ${toString config.boot.kernelParams}"
      submenuentry "Verbose" {
        add_options "${debugFlags}"
      }
      submenuentry "Console Only" {
        add_options "systemd.unit=multi-user.target"
      }
      submenuentry "Rescue" {
        add_options "systemd.unit=rescue.target ${debugFlags}"
      }
    }

    menuentry "Windows 11" {
      icon ${icons}/os_win10.png
      loader /EFI/Microsoft/Boot/bootmgfw.efi
      ostype Windows
    }
  '';
in
{
  system.boot.loader.id = "refind";
  system.build.installBootLoader = pkgs.writeScript "installBootLoader.sh" ''
    #!${pkgs.bash}/bin/bash

    TOPLEVEL=$1
    EFI_INFO=$(${lsblk} -o NAME,PARTTYPE,PKNAME,PARTTYPENAME,FSTYPE \
      | ${grep} -i "EFI" | ${grep} -i "vfat" | ${head} -n1)
    DISK=$(echo "$EFI_INFO" | ${awk} '{print $3}')
    BASE=$(${basename} $TOPLEVEL)

    ${efibootmgr} | ${grep} -i "rEFind" | ${awk} '{print $1}' \
      | ${sed} 's/Boot//' | ${sed} 's/\*//' \
      | while read entry; do ${efibootmgr} -b "$entry" -B &> /dev/null; done

    ${efibootmgr} --create --disk /dev/$DISK --part 1 \
      --loader /EFI/refind/refind_x64.efi --label "rEFInd" \
      --unicode &> /dev/null

    if [ ! -d ${efi}/refind ]; then
      ${mkdir} -p ${efi}/BOOT ${efi}/refind/themes ${efi}/refind/drivers_x64
      ${cp} ${refind}/refind_x64.efi ${efi}/refind/refind_x64.efi
      ${cp} ${refind}/refind_x64.efi ${efi}/BOOT/BOOTX64.efi
      ${cp} -r ${refind}/icons ${efi}/refind/icons
      ${cp} -r ${refind}/fonts ${efi}/refind/fonts
      ${cp} -r ${inputs.catppuccin-refind} ${efi}/refind/themes/catppuccin
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/btrfs_x64.efi
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/exfat_x64.efi
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/f2fs_x64.efi
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/ntfs_x64.efi
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/zfs_x64.efi
    fi

    if [ ! -d ${efi}/tools ]; then
      ${mkdir} -p ${efi}/tools
      ${cp} ${edk2}/shell.efi ${efi}/tools/shellx64.efi
      ${cp} ${memtest}/BOOTX64.efi ${efi}/tools/memtest86.efi
      ${cp} ${fwupd}/fwupdx64.efi ${efi}/tools/fwupx64.efi
    fi

    [[ -f ${efi}/kernel ]] && rm ${efi}/kernel
    cp ${kernel} ${efi}/kernel

    [[ -f ${efi}/initrd ]] && rm ${efi}/initrd
    cp ${initrd} ${efi}/initrd

    ${cp} ${kernel} ${initrd} /boot/emergency/
    echo "$BASE" > /boot/emergency/actual.txt

    ${cat} > ${efi}/refind/refind.conf << EOF
      ${refind-opts}
      ${entries}
    EOF

    if [ -d /nix/persist/var/lib/sbctl ]; then
      ${sbctl} sign -s ${efi}/refind/refind_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/tools/shellx64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/tools/memtest86.efi &> /dev/null
      ${sbctl} sign -s ${efi}/tools/fwupx64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/drivers_x64/btrfs_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/drivers_x64/exfat_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/drivers_x64/f2fs_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/drivers_x64/ntfs_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/drivers_x64/zfs_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/kernel
    fi
  '';
  #${sbctl} sign -s ${efi}/initrd
  #--cmdline="init=$TOPLEVEL/init ${toString config.boot.kernelParams}" \
}
