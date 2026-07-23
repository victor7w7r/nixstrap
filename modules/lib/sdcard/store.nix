{
  sdcard.lib.store = closureInfo: isHDD: storeLabel: isEntireDisk: ''
    mkdir -p repart.d

    useSubvols=${if isEntireDisk then "true" else "false"}

    cat <<EOF > repart.d/10-store.conf
    [Partition]
    Type=root
    Label=${storeLabel}
    Format=${if isHDD then "xfs" else "btrfs"}
    SizeMinBytes=12G
    Minimize=no
    Weight=1000
    EOF

    if [ "$useSubvols" = "true" ]; then
      echo "CopyFiles=${closureInfo}/registration:/@nix/nix-path-registration" >> repart.d/10-store.conf
      mkdir -p empty_etc empty_persist
      echo "CopyFiles=empty_etc:/@etc" >> repart.d/10-store.conf
      echo "CopyFiles=empty_persist:/@persist" >> repart.d/10-store.conf
    else
      echo "CopyFiles=${closureInfo}/registration:/nix-path-registration" >> repart.d/10-store.conf
    fi

    echo "Filtering store packages with spaces ..."
    for path in $(cat ${closureInfo}/store-paths); do
      if find "$path" -name "* *" -print -quit | grep -q .; then
        echo "Skipping: $path"
        continue
      fi

      if find "$path" -type l -exec readlink {} + | grep -q " "; then
        echo "Skipping: $path"
        continue
      fi

      targetPath="''${path#/nix}"

      if [ "$useSubvols" = "true" ]; then
        echo "CopyFiles=$path:/@nix/store$targetPath" >> repart.d/10-store.conf
      else
       echo "CopyFiles=$path:$targetPath
        echo "CopyFiles=$path:$targetPath" >> repart.d/10-store.conf
      fi
    done

    ${
      if isHDD then
        ''export SYSTEMD_REPART_MKFS_OPTIONS_XFS="-f -m crc=1 -n size=64k"''
      else
        ''export SYSTEMD_REPART_MKFS_OPTIONS_BTRFS="-f"''
    }

    echo "Creating and compressing store partition..."
    faketime -f "1970-01-01 00:00:01" fakeroot \
      systemd-repart --root=. --dry-run=no --empty=create --size=auto --definitions=./repart.d store.img
    ${
      if isEntireDisk then
        ''
          STORE_START=$(partx boot.img -o START --nr 3 -g --pairs | cut -d'=' -f2)
          STORE_SECTORS=$(partx boot.img -o SECTORS --nr 3 -g --pairs | cut -d'=' -f2)

          truncate -s $((STORE_SECTORS * 512)) store.img
          dd conv=notrunc,fsync if=store.img of=boot.img seek=$STORE_START count=$STORE_SECTORS
          zstd -T$NIX_BUILD_CORES --rm boot.img && cp -a ./boot.img.zst $out/
        ''
      else
        ''
          zstd -T$NIX_BUILD_CORES --rm store.img && cp -a ./store.img.zst $out/
        ''
    }
  '';
}
