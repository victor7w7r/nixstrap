{ lib, ... }: {
  sdcard.lib.image = bootSize: nextPartSize: useGpt: nextPartName: isEntireDisk: ''
    mkdir -p $out

    echo "Creating sdcard partition map..."
    bootSizeMB=${toString bootSize}
    nextPartSizeMB=${toString nextPartSize}
    swapSizeMB=${if isEntireDisk && useGpt then "32768" else "0"}

    bootImgSize=$(( (gap + bootSizeMB + swapSizeMB + nextPartSizeMB) * 1024 * 1024 + 16 * 1024 * 1024 ))
    truncate -s $bootImgSize boot.img
    gap=8

    sfdisk --no-reread --no-tell-kernel boot.img <<EOF
      label: ${if useGpt then "gpt" else "dos"}
      label-id: ${if useGpt then "2178694E-0000-4000-8000-000000000000" else "0x2178694e"}

      start=''${gap}M, size=''${bootSizeMB}M, ${
        if useGpt then
          ''type=C12A7328-F81F-11D2-BA4B-00A0C93EC93B, name="BOOT", attrs="LegacyBIOSBootable"''
        else
          "type=b, bootable"
      }
      ${lib.optionalString (isEntireDisk && useGpt) ''
        start=$((gap + bootSizeMB))M, size=''${swapSizeMB}M, type=0657FA6D-A451-463C-B3A4-222264E33E17, name="SWAP"
      ''}

      start=$((gap + bootSizeMB + swapSizeMB))M, size=''${nextPartSizeMB}M, ${
        if useGpt then ''type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, name="${nextPartName}"'' else "type=83"
      }
    EOF
  '';
}
