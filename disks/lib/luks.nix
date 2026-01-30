{
  allowDiscards ? true,
  content,
  keyFile ? "/tmp/key.txt",
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
    postCreateHook = ''
      cryptsetup config /dev/disk/by-partlabel/disk-main-${name} --label "${name}"
    '';
  };
}
