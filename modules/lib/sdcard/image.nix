{ lib, ... }: {
  sdcard.lib.image = bootSize: nextPartSize: nextPartName: isEntireDisk: ''
    mkdir -p $out

    echo "Creating sdcard partition map..."
    gap=8
    bootSizeMB=${toString bootSize}
    nextPartSizeMB=${toString nextPartSize}
    swapSizeMB=${if isEntireDisk then "32768" else "0"}

    bootImgSize=$(( (gap + bootSizeMB + swapSizeMB + nextPartSizeMB) * 1024 * 1024 + 16 * 1024 * 1024 ))
    truncate -s $bootImgSize boot.img

    sfdisk --no-reread --no-tell-kernel boot.img <<EOF
      label: gpt
      label-id: 2178694E-0000-4000-8000-000000000000
      start=''${gap}M, size=''${bootSizeMB}M, type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, name="disk-main-esp", attrs="LegacyBIOSBootable"
      ${lib.optionalString isEntireDisk ''
        start=$((gap + bootSizeMB))M, size=''${swapSizeMB}M, type=0657FA6D-A451-463C-B3A4-000000000000, name="disk-main-swapcrypt"
      ''}
      start=$((gap + bootSizeMB + swapSizeMB))M, size=''${nextPartSizeMB}M, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, name="disk-main-${nextPartName}"
    EOF
  '';
}
