{
  name ? "syscrypt",
  partlabel ? "systempv",
  vg ? "vg0",
  allowDiscards ? true,
  size ? "100%",
  group ? "main",
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
      cryptsetup config /dev/disk/by-partlabel/disk-${group}-${partlabel} --label "${name}"
    '';
  };
}
