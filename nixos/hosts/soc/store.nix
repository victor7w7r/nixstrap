{
  closureInfo,
  storeFs ? "xfs",
  storeLabel ? "store",
}:
let
  fsOpts =
    if storeFs == "xfs" then
      ''export SYSTEMD_REPART_MKFS_OPTIONS_XFS="-f -m crc=1 -n size=64k"''
    else
      "--compression=zstd --background_compression=zstd";
  fakeInvoke = ''faketime -f "1970-01-01 00:00:01" fakeroot'';
in
''
  ${fsOpts}

  mkdir -p repart.d
  cat <<EOF > repart.d/10-store.conf
  [Partition]
  Type=root
  Label=${storeLabel}
  Format=xfs
  SizeMinBytes=1G
  CopyFiles=${closureInfo}/registration:/store/.nix-path-registration
  EOF

  for path in $(cat ${closureInfo}/store-paths); do
    if find "$path" -name "* *" -print -quit | grep -q .; then
      echo "Skipping: $path"
      continue
    fi

    if find "$path" -type l -exec readlink {} + | grep -q " "; then
      echo "Skipping: $path"
      continue
    fi
    echo "CopyFiles=$path:''${path#/nix}" >> repart.d/10-store.conf
  done

  ${fakeInvoke} systemd-repart --dry-run=no --empty=create \
    --size=auto --definitions=./repart.d store.img
''
