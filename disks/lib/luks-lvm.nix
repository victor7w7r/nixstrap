{
  name ? "syscrypt",
  vg ? "vg0",
  allowDiscards ? true,
  size ? "100%",
  isForTest ? false,
  keyFile ? "/tmp/key.txt",
  priority ? 3,
}:
{
  inherit size priority;
  content = {
    inherit name;
    type = "luks";
    content = {
      inherit vg;
      type = "lvm_pv";
    };
    settings = { inherit keyFile allowDiscards; };
    preCreateHook = (if isForTest then ''echo -n "test" > /tmp/key.txt'' else "");
    postCreateHook = ''
      cryptsetup config /dev/disk/by-partlabel/disk-main-${name} --label "${name}"
    '';
  };
}
