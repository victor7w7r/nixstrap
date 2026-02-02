{
  allowDiscards ? true,
  content,
  isForTest ? false,
  keyFile ? "/tmp/key.txt",
  name ? "systempv",
  priority ? 3,
  size ? "100%",
}:
{
  inherit size priority;
  content = {
    type = "luks";
    inherit name content;
    settings = { inherit keyFile allowDiscards; };
    preCreateHook = (if isForTest then ''echo -n "test" > /tmp/key.txt'' else "");
    postCreateHook = ''
      cryptsetup config /dev/disk/by-partlabel/disk-main-${name} --label "${name}"
    '';
  };
}
