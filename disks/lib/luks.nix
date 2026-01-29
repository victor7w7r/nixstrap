{
  allowDiscards ? true,
  generateRandomKey ? true,
  content,
  keyFile ? "/tmp/passphrase.sec",
  label ? "syscrypt",
  name ? "syscrypt",
  priority ? 3,
  size ? "100%",
}:
{
  inherit size priority;
  content = {
    type = "luks";
    inherit name content;
    settings = { inherit keyFile allowDiscards; };
    preCreateHook =
      if generateRandomKey then
        ''
          dd if=/dev/urandom of=/tmp/${name}.sec bs=1 count=64
          chmod 0400 /tmp/${name}.sec
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
              /tmp/${name}.sec -d ${keyFile}
          ''
        else
          ""
      }
    '';
  };
}
