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

  mkdir -p repart.d
  cat <<EOF > repart.d/10-store.conf
    [Partition]
    Type=root
    Format=${storeFs}
    Label=${storeLabel}
    CopyFiles=./rootImage
    MakeFileSystemOptions=${opts}
    Minimize=yes
  EOF

  ${fakeInvoke} ${pkgs.systemdUkify}/bin/systemd-repart \
    --definitions=./repart.d \
    --empty=create \
    --size=auto \
    --dry-run=no \
    store.img
''
