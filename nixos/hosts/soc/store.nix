{
  closureInfo,
  storeFs ? "xfs",
  storeLabel ? "store",
}:
let
  fsOpts =
    if storeFs == "xfs" then
      ''export SYSTEMD_REPART_MKFS_OPTIONS_XFS="-f -m crc=1,reflink=1 -n size=64k"''
    else
      "--compression=zstd --background_compression=zstd";
in
''
  export LIBGUESTFS_BACKEND=direct
  ${fsOpts}

  mkdir -p repart.d
  cat <<EOF > repart.d/10-root.conf
  [Partition]
  Type=root
  Label=${storeLabel}
  SizeMinBytes=1G
  EOF

  systemd-repart --definitions=$PWD/repart.d --empty=create --size=auto --dry-run=no store.img

  mkdir -p ./rootImage/nix/store
  cp ${closureInfo}/registration ./rootImage/nix-path-registration
  echo "Hola desde el host, probando el XFS" > prueba.txt
  #tar-in <(tar -cf - -C / -T ${closureInfo}/store-paths -C $PWD/rootImage .) /

  guestfish -a store.img <<EOF
    run
    mkfs xfs /dev/sda1
    mount /dev/sda1 /
    upload prueba.txt /prueba_adentro.txt
    sync
    quit
  EOF
''
