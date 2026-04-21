{
  pkgs,
  closureInfo,
  storeFs ? "xfs",
  storeLabel ? "store",
}:
let
  fakeInvoke = ''faketime -f "1970-01-01 00:00:01" fakeroot'';
  opts =
    if storeFs == "xfs" then
      "-f -m crc=1,reflink=1 -n size=64k"
    else
      "--compression=zstd --background_compression=zstd";
in
''
    mkdir -p ./rootImage/nix/store
    xargs -I % cp -a --reflink=auto % -t ./rootImage/nix/store/ < ${closureInfo}/store-paths
    (
      GLOBIGNORE=".:.."
      shopt -u dotglob
      for f in ./files/*; do cp -a --reflink=auto -t ./rootImage/ "$f"; done
    )

    cp ${closureInfo}/registration ./rootImage/nix-path-registration

    numInodes=$(find ./rootImage | wc -l)
    numDataBlocks=$(du -s -c -B 4096 --apparent-size ./rootImage | tail -1 | awk '{ print int($1 * 1.20) }')
    bytes=$((2 * 4096 * $numInodes + 4096 * $numDataBlocks))
    bytes=$((bytes + 100 * 1024 * 1024))
    bytes=$((bytes * 15 / 10))
    bytes=$(( ((bytes + 2097151) / 2097152) * 2097152 ))

    truncate -s $bytes ./root.img

    ${
      if storeFs == "btrfs" then
        ''${fakeInvoke} mkfs.btrfs -L "${storeLabel}" -r ./rootImage ./root.img''
      else
        ''
          mkdir -p repart.d
          cat <<EOF > repart.d/10-root.conf
          [Partition]
          Type=root
          Format=${storeFs}
          Label=${storeLabel}
          CopyFiles=./rootImage
          MakeFileSystemOptions=${opts}
          Minimize=yes
          EOF
          ${fakeInvoke} ${pkgs.systemdUkify}/bin/systemd-repart --definitions=./repart.d \
            --empty=create --size=auto --dry-run=no --root=./rootImage \
            ./root.img
        ''
    }
    partitionSizeBlocks=$(du -B 512 --apparent-size ./root.img | awk '{ print $1 }')
    totalImageSize=$(( (partitionSizeBlocks * 512) + (2 * 1024 * 1024) ))

    truncate -s $totalImageSize $storeImg

    sfdisk --no-reread --no-tell-kernel $storeImg <<EOF
      label: gpt
      label-id: 2178694E-5869-4E69-8000-000000000000

      start=2048, size=$partitionSizeBlocks, type=0FC63DAF-8483-4772-8E79-3D69D8477DE4, name="nix-store"
  EOF

    eval $(partx $storeImg -o START,SECTORS --nr 1 --pairs)
    dd conv=notrunc if=./root.img of=$storeImg seek=$START count=$SECTORS
''
