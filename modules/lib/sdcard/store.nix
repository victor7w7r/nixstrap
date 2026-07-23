{ lib, ... }: {
  sdcard.lib.store = closureInfo: isHDD: storeLabel: isEntireDisk: ''
    mkdir -p repart.d

    useSubvols=${if isEntireDisk then "true" else "false"}

    ${lib.optionalString (!isEntireDisk) ''
      echo "Creating swap partition layout..."
      cat <<EOF > repart.d/05-swap.conf
      [Partition]
      Type=swap
      Label=disk-sda-swapcrypt
      SizeMinBytes=4G
      SizeMaxBytes=4G
      Weight=100
      EOF
    ''}

    cat <<EOF > repart.d/10-store.conf
    [Partition]
    Type=root
    Label=${if isEntireDisk then storeLabel else "disk-sda-system"}
    Format=${if isHDD then "xfs" else "btrfs"}
    SizeMinBytes=${if isEntireDisk then "64G" else "16G"}
    Minimize=no
    ${if isEntireDisk then "Subvolumes=@etc @persist @nix" else ""}
    ${if isEntireDisk then "DefaultSubvolume=@nix" else ""}
    ${if isEntireDisk then "MountPoint=/:subvol=@nix,compress=zstd:3" else ""}
    Weight=1000
    EOF
    echo "CopyFiles=${closureInfo}/registration:/nix-path-registration" >> repart.d/10-store.conf

    echo "Filtering store packages with spaces ..."
    for path in $(cat ${closureInfo}/store-paths); do
     if [ "$useSubvols" = "false" ]; then
      if find "$path" -name "* *" -print -quit | grep -q .; then
        echo "Skipping: $path"
        continue
      fi

      if find "$path" -type l -exec readlink {} + | grep -q " "; then
        echo "Skipping: $path"
        continue
      fi
    fi
      targetPath="''${path#/nix}"
      echo "CopyFiles=$path:$targetPath" >> repart.d/10-store.conf
    done

    export SYSTEMD_REPART_MKFS_OPTIONS_${
      if isHDD then ''XFS="-f -m crc=1 -n size=64k"'' else ''BTRFS="-f"''
    }

    echo "Creating and compressing store partition..."
    faketime -f "1970-01-01 00:00:01" fakeroot \
      systemd-repart --root=/ --dry-run=no --empty=create --size=auto --definitions=./repart.d store.img
    ${
      if isEntireDisk then
        ''
          STORE_START=$(partx boot.img -o START --nr 3 -g --pairs | cut -d'=' -f2 | tr -d '"')
          STORE_SECTORS=$(partx boot.img -o SECTORS --nr 3 -g --pairs | cut -d'=' -f2 | tr -d '"')
          TMP_START=$(partx store.img -o START --nr 1 -g --pairs | cut -d'=' -f2 | tr -d '"')
          dd bs=512 conv=notrunc,fsync if=store.img of=boot.img skip=$TMP_START seek=$STORE_START count=$STORE_SECTORS
          zstd -T$NIX_BUILD_CORES --rm boot.img && cp -a ./boot.img.zst $out/
        ''
      else
        ''
          zstd -T$NIX_BUILD_CORES --rm store.img && cp -a ./store.img.zst $out/
        ''
    }
  '';
}
