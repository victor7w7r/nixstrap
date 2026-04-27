{
  content,
  name,
  group,
  priority,
  size ? "100%",
  allowDiscards ? true,
  isForTest ? false,
  postCreate ? "",
  keyFile ? "/tmp/key.txt",
}:
{
  inherit size priority;
  content = {
    inherit name content;
    type = "luks";
    settings = { inherit keyFile allowDiscards; };
    preCreateHook = (if isForTest then ''echo -n "test" > /tmp/key.txt'' else "");
    postCreateHook = ''
      cryptsetup config /dev/disk/by-partlabel/disk-${group}-${name} --label "${name}"
      ${postCreate}
    '';
  };
}
