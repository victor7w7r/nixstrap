{
  persistSize ? 2048,
  persistLabel ? "persist",
}:
let
  fakeInvoke = ''faketime -f "1970-01-01 00:00:01" fakeroot'';
in
''
  persistSizeMB=${toString persistSize}
  bytes=$(( persistSizeMB * 1024 * 1024 ))
  bytes=$(( ((bytes + 2097151) / 2097152) * 2097152 ))

  truncate -s $bytes ./persist.img

  mkdir -p ./emptySource
  mkdir -p repart-persist.d
  cat <<EOF > repart.d/10-root.conf
  [Partition]
  Type=linux-generic
  Format=f2fs
  Label=${persistLabel}
  CopyFiles=./emptySource
  MakeFileSystemOptions=-O extra_attr,compression,flexible_inline_xattr -f
  Minimize=yes
  SizeMinBytes=$bytes
  SizeMaxBytes=$bytes
  EOF

  ${fakeInvoke} systemd-repart --definitions=.repart-persist.d \
    --empty=create --size=auto --dry-run=no ./persist.img

  fsck.f2fs -f ./persist.img ||true
''
