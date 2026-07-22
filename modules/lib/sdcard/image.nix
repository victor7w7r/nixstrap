{
  sdcard.lib.image = bootSize: nextPartSize: useGpt: nextPartName: populateFirmwareCommands: ''
    echo "Creating boot partition..."
    bootSizeMB=${toString bootSize}
    nextPartSizeMB=${toString nextPartSize}

    systemImgSize=$(( (gap + bootSizeMB + nextPartSizeMB) * 1024 * 1024 + 16 * 1024 * 1024 ))
    truncate -s $systemImgSize boot.img
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
      start=$((gap + bootSizeMB))M, size=''${nextPartSizeMB}M, ${
        if useGpt then ''type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, name="${nextPartName}"'' else "type=83"
      }
    EOF

    eval $(partx boot.img -o START,SECTORS --nr 1 --pairs)
    truncate -s $((SECTORS * 512)) firmware_part.img
    mkfs.vfat --invariant -i 0x2178694e -n BOOT firmware_part.img
    mkdir firmware

    echo "Populating firmware..."
    ${populateFirmwareCommands}

    find firmware -exec touch --date=2000-01-01 {} +
    cd firmware
    for d in $(find . -type d -mindepth 1 | sort); do
      faketime "2000-01-01 00:00:00" mmd -i ../firmware_part.img "::/$d"
    done
    for f in $(find . -type f | sort); do
      mcopy -pvm -i ../firmware_part.img "$f" "::/$f"
    done
    cd ..

    fsck.vfat -vn firmware_part.img
    dd conv=notrunc if=firmware_part.img of=boot.img seek=$START count=$SECTORS
    eval $(partx boot.img -o START,SECTORS --nr 2 --pairs)
  '';
}
