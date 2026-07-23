{
  sdcard.lib.persist =
    persistLabel:
    ''faketime -f "1970-01-01 00:00:01" fakeroot''
    |> (fakeInvoke: ''
      echo "Creating persist partition in f2fs..."

      persistSizeMB=2048
      bytes=$(( persistSizeMB * 1024 * 1024 ))

      truncate -s $bytes ./persist.img
      ${fakeInvoke} mkfs.f2fs -f -l "${persistLabel}" -O extra_attr,compression,flexible_inline_xattr -q ./persist.img
      ${fakeInvoke} fsck.f2fs -f ./persist.img || true

      eval $(partx boot.img -o START,SECTORS --nr 2 --pairs)
      dd bs=512 conv=notrunc,fsync if=./persist.img of=boot.img seek=$START count=$SECTORS
    '');
}
