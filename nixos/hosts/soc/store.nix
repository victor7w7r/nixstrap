{
  closureInfo,
  isHDD,
  storeLabel ? "store",
}:
let
  fsOpts =
    if isHDD then
      ''export SYSTEMD_REPART_MKFS_OPTIONS_EXT4="-E lazy_itable_init=1,lazy_journal_init=1 -m 0 -i 8192 -J size=16 -O 64bit,dir_index,dir_nlink,extent,ext_attr,extra_isize,filetype,flex_bg,has_journal,metadata_csum,resize_inode,uninit_bg,sparse_super"''
    else
      ''export SYSTEMD_REPART_MKFS_OPTIONS_BCACHEFS="--compression=zstd --background_compression=zstd"'';
  fakeInvoke = ''faketime -f "1970-01-01 00:00:01" fakeroot'';
in
''
  ${fsOpts}

  mkdir -p repart.d
  cat <<EOF > repart.d/10-store.conf
  [Partition]
  Type=root
  Label=${storeLabel}
  Format=${if isHDD then "ext4" else "bcachefs"}
  SizeMinBytes=10G
  PaddingBytes=2G
  Minimize=no
  Weight=1000
  CopyFiles=${closureInfo}/registration:/nix-path-registration
  EOF

  for path in $(cat ${closureInfo}/store-paths); do
    echo "CopyFiles=$path:''${path#/nix}" >> repart.d/10-store.conf
  done

  ${fakeInvoke} systemd-repart --dry-run=no --empty=create \
    --size=auto --definitions=./repart.d store.img
''
