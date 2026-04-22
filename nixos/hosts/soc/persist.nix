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

  ${fakeInvoke} mkfs.f2fs -f -l "${persistLabel}" \
    -O extra_attr,compression,flexible_inline_xattr -q ./persist.img

  ${fakeInvoke} fsck.f2fs -f ./persist.img || true
''
