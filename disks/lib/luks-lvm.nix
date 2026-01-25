{
  allowDiscards ? true,
  generateRandomKey ? true,
  keyFile ? "/tmp/pass.key",
  name ? "systempv",
  postHook ? null,
  priority ? 3,
  label ? "systempv",
  randomKeyName ? "key.key",
  size ? "100%",
  vg ? "vg0",
}:
{
  inherit size priority;
  content = {
    type = "luks";
    inherit name;
    settings = { inherit keyFile allowDiscards; };
    content = {
      inherit vg;
      type = "lvm_pv";
    };
    preCreateHook =
      if generateRandomKey then
        ''
          dd if=/dev/urandom of=/root/nixstrap/${randomKeyName} bs=1 count=64
          chmod 0400 /root/nixstrap/${randomKeyName}
          git config --global --add safe.directory /root/nixstrap
          cd /root/nixstrap && git add . && git commit -m "Add Key"
        ''
      else
        null;
    postCreateHook = ''
      ${
        if generateRandomKey then
          ''
            cryptsetup config /dev/disk/by-partlabel/disk-main-${name} \
              --label "${label}"
            cryptsetup luksAddKey /dev/disk/by-partlabel/disk-main-${name} \
              /root/nixstrap/${randomKeyName} -d ${keyFile}
          ''
        else
          ""
      }
      ${if (postHook != null) then postHook else ""}
    '';
  };
}
