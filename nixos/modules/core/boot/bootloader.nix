{
  pkgs,
  host,
  inputs,
  config,
  ...
}:
let
  efi = "/boot/EFI";
  cat = "${pkgs.coreutils}/bin/cat";
  cp = "${pkgs.coreutils}/bin/cp";
  rm = "${pkgs.coreutils}/bin/rm";
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
  ukify = "${pkgs.buildPackages.systemdUkify}/lib/systemd/ukify";
  basename = "${pkgs.coreutils}/bin/basename";
  wget = "${pkgs.wget2}/bin/wget2";
  efifs = "https://github.com/pbatard/EfiFs/releases/download/v1.11";
  mocha = "themes/catppuccin/assets/mocha";
  initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
  latest = config.boot.kernelPackages.kernel;
  kernelFile = config.system.boot.loader.kernelFile;
  #secure = config.specialisation.hardened.configuration.boot.kernelPackages.kernel;

  refind-opts = ''
    banner ${mocha}/background.png
    banner_scale fillscreen
    dont_scan_dirs +,EFI
    enable_touch
    enable_mouse
    icons_dir ${mocha}/icons
    hideui hwtest,arrows,badges
    scanfor manual,external
    showtools shell, memtest, bootorder, apple_recovery, windows_recovery
    selection_big ${mocha}/selection_big.png
    selection_small ${mocha}/selection_small.png
    timeout 2
    use_nvram false
  '';

  debugFlags = "boot.trace=1 debug udev.log_level=7 rd.systemd.show_status=true";

  winEntry = ''
    menuentry "Windows 11" {
      icon /EFI/refind/${mocha}/icons/os_win10.png
      loader /EFI/Microsoft/Boot/bootmgfw.efi
      ostype Windows
    }
  '';

  nixosBuilder =
    {
      name ? "NixOS",
      loader ? "/EFI/nixos.efi",
      subentries ? ''
        submenuentry "Verbose" {
          add_options "${debugFlags}"
        }
        submenuentry "Console Only" {
          add_options "systemd.unit=multi-user.target"
        }
        submenuentry "Rescue" {
          add_options "systemd.unit=rescue.target"
        }
      '',
    }:
    ''
      menuentry "${name}" {
        icon /EFI/refind/${mocha}/icons/os_nixos.png
        loader ${loader}
        ostype Linux
        options "init=$TOPLEVEL/init ${toString config.boot.kernelParams}"
        ${subentries}
      }
    '';
in
{
  system.boot.loader.id = "refind";
  system.build.installBootLoader = pkgs.writeScript "installBootLoader.sh" ''
    #!${pkgs.bash}/bin/bash

    TOPLEVEL=$1
    BASE=$(${basename} $TOPLEVEL)

    [[ ! -d ${efi}/BOOT ]] && ${mkdir} -p ${efi}/BOOT

    if [ ! -d ${efi}/refind ]; then
      echo "Setup Refind"

      [[ -f ${efi}/BOOT/BOOTX64.efi ]] && ${rm} ${efi}/BOOT/BOOTX64.efi

      ${cp} -r ${refind} ${efi}/
      ${cp} ${refind}/refind_x64.efi ${efi}/BOOT/BOOTX64.efi

      ${rm} -rf ${efi}/refind/docs ${efi}/refind/refind.conf-sample ${efi}/refind/images ${efi}/refind/drivers_x64/ext*
      ${rm} -rf ${efi}/refind/drivers_x64/hfs_x64.efi ${efi}/refind/drivers_x64/iso9660_x64.efi  ${efi}/refind/drivers_x64/reiserfs_x64.efi
      ${mkdir} -p ${efi}/refind/themes && ${cp} -r ${inputs.catppuccin-refind} ${efi}/refind/themes/catppuccin
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/ntfs_x64.efi &> /dev/null

      ${cp} ${edk2}/shell.efi ${efi}/refind/tools_x64/shellx64.efi
      ${cp} ${memtest}/BOOTX64.efi ${efi}/refind/tools_x64/memtest86.efi
      ${cp} ${fwupd}/fwupdx64.efi ${efi}/refind/tools_x64/fwupx64.efi
    fi

    EFI_INFO=$(${lsblk} -o NAME,PARTTYPE,PKNAME,PARTTYPENAME,FSTYPE \
      | ${grep} -i "EFI" | ${grep} -i "vfat" | ${head} -n1)
    DISK=$(echo "$EFI_INFO" | ${awk} '{print $3}')

    echo "Setup EFI Entries..."
    ${efibootmgr} | ${grep} -i "rEFind" | ${awk} '{print $1}' \
      | ${sed} 's/Boot//' | ${sed} 's/\*//' \
      | while read entry; do ${efibootmgr} -b "$entry" -B &> /dev/null; done

    ${efibootmgr} --create --disk /dev/$DISK --part 1 \
      --loader /EFI/refind/refind_x64.efi --label "rEFInd" \
      --unicode &> /dev/null

    [[ -f ${efi}/nixos.efi ]] && ${rm} ${efi}/nixos.efi

    ${ukify} build --linux="${latest}/${kernelFile}" --initrd="${initrd}" \
      --uname="${latest.modDirVersion}" \
      --os-release="${config.system.build.etc}/etc/os-release" \
      --output=${efi}/nixos.efi

    ${mkdir} -p /boot/emergency/cache
    ${cp} ${efi}/nixos.efi /boot/emergency/cache/nixos-$BASE.efi
    echo "$BASE" > /boot/emergency/actual.txt

    ${cat} > ${efi}/refind/refind.conf << EOF
      ${refind-opts}
      ${nixosBuilder { }}
      ${if (host != "v7w7r-nixvm") && (host != "v7w7r-youyeetoox1") then winEntry else ""}
    EOF

    if [ -d /var/lib/sbctl/keys ]; then
      ${sbctl} sign -s ${efi}/refind/refind_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/tools_x64/shellx64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/tools_x64/memtest86.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/tools_x64/gptsync_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/tools_x64/fwupx64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/drivers_x64/btrfs_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/refind/drivers_x64/ntfs_x64.efi &> /dev/null
      ${sbctl} sign -s ${efi}/nixos.efi
    fi
  '';
}
