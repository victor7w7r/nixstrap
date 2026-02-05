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
  basename = "${pkgs.coreutils}/bin/basename";
  wget = "${pkgs.wget2}/bin/wget2";
  efifs = "https://github.com/pbatard/EfiFs/releases/download/v1.11";
  mocha = "themes/catppuccin/assets/mocha";
  initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
  latest = config.boot.kernelPackages.kernel;
  kernelFile = config.system.boot.loader.kernelFile;
  #zen = config.specialisation."zen-mode".configuration.boot.kernelPackages.kernel;
  #lqx = config.specialisation.lqx.configuration.boot.kernelPackages.kernel;
  #lts = config.specialisation.lts.configuration.boot.kernelPackages.kernel;
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

  nixosBuilder =
    {
      name ? "NixOS",
      loader ? "/EFI/kernel",
      initrd ? "/EFI/initrd",
      subentries ? ''
        submenuentry "Verbose" {
          add_options "${debugFlags}"
        }
        submenuentry "Console Only" {
          add_options "systemd.unit=multi-user.target"
        }
        submenuentry "Rescue" {
          add_options "systemd.unit=rescue.target ${debugFlags}"
        }
        #submenuentry "LTS" {
        #  loader /EFI/kernel-lts
        #  initrd
        #  options
        #}
        #submenuentry "LQX" {
        #  loader /EFI/kernel-lqx
        #  initrd
        #  options
        #}
        #submenuentry "Zen" {
        #  loader /EFI/kernel-zen
        #  initrd
        #  options
        #}
        #submenuentry "Hardened" {
        #  loader /EFI/kernel-hardened
        #  initrd
        #  options
        #}
      '',
    }:
    ''
      menuentry "${name}" {
        icon /EFI/refind/${mocha}/icons/os_nixos.png
        loader ${loader}
        initrd ${initrd}
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
    EFI_INFO=$(${lsblk} -o NAME,PARTTYPE,PKNAME,PARTTYPENAME,FSTYPE \
      | ${grep} -i "EFI" | ${grep} -i "vfat" | ${head} -n1)
    DISK=$(echo "$EFI_INFO" | ${awk} '{print $3}')
    BASE=$(${basename} $TOPLEVEL)

    echo "Setup EFI Entries..."
    ${efibootmgr} | ${grep} -i "rEFind" | ${awk} '{print $1}' \
      | ${sed} 's/Boot//' | ${sed} 's/\*//' \
      | while read entry; do ${efibootmgr} -b "$entry" -B &> /dev/null; done

    ${efibootmgr} --create --disk /dev/$DISK --part 1 \
      --loader /EFI/refind/refind_x64.efi --label "rEFInd" \
      --unicode &> /dev/null

    if [ ! -d ${efi}/refind ]; then
      echo "Setup Refind, downloading drivers..."
      ${mkdir} -p ${efi}/BOOT ${efi}/refind/themes ${efi}/refind/drivers_x64
      ${cp} ${refind}/refind_x64.efi ${efi}/refind/refind_x64.efi
      ${cp} ${refind}/refind_x64.efi ${efi}/BOOT/BOOTX64.efi
      ${cp} -r ${refind}/icons ${efi}/refind/icons
      ${cp} -r ${refind}/fonts ${efi}/refind/fonts
      ${cp} -r ${inputs.catppuccin-refind} ${efi}/refind/themes/catppuccin
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/btrfs_x64.efi &> /dev/null
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/exfat_x64.efi &> /dev/null
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/f2fs_x64.efi &> /dev/null
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/ntfs_x64.efi &> /dev/null
      ${wget} -P ${efi}/refind/drivers_x64 ${efifs}/zfs_x64.efi &> /dev/null
    fi

    if [ ! -d ${efi}/tools ]; then
      echo "Setup Tools..."
      ${mkdir} -p ${efi}/tools
      ${cp} ${edk2}/shell.efi ${efi}/tools/shellx64.efi
      ${cp} ${memtest}/BOOTX64.efi ${efi}/tools/memtest86.efi
      ${cp} ${fwupd}/fwupdx64.efi ${efi}/tools/fwupx64.efi
    fi

    [[ -f ${efi}/kernel ]] && ${rm} ${efi}/kernel
    ${cp} ${latest}/${kernelFile} ${efi}/kernel

    [[ -f ${efi}/initrd ]] && ${rm} ${efi}/initrd
    ${cp} ${initrd} ${efi}/initrd

    ${mkdir} -p /boot/emergency/cache
    ${cp} ${latest}/${kernelFile} /boot/emergency/cache/kernel-$BASE
    ${cp} ${initrd} /boot/emergency/cache/initrd-$BASE
    echo "$BASE" > /boot/emergency/actual.txt

    ${cat} > ${efi}/refind/refind.conf << EOF
      ${refind-opts}
      ${nixosBuilder { }}
      menuentry "Windows 11" {
        icon /EFI/refind/${mocha}/icons/os_win10.png
        loader /EFI/Microsoft/Boot/bootmgfw.efi
        ostype Windows
      }
    EOF

    if [ -d /var/lib/sbctl/keys ]; then
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

  /*
    cp ${zen}/${kernelFile} ${efi}/kernel-zen
    cp ${lqx}/${kernelFile} ${efi}/kernel-lqx
    cp ${lts}/${kernelFile} ${efi}/kernel-lts
    cp ${secure}/${kernelFile} ${efi}/kernel-hardened
  */
}
