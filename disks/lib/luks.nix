{
  name,
  group,
  priority ? null,
  size ? "100%",
  content ? null,
  allowDiscards ? true,
  isForTest ? false,
  entireDisk ? false,
  postCreate ? "",
  keyFile ? "/tmp/key.txt",
}:
let
  body = {
    inherit name content;
    type = "luks";
    settings = { inherit keyFile allowDiscards; };
    preCreateHook = (if isForTest then ''echo -n "test" > /tmp/key.txt'' else "");
    postCreateHook = ''
      cryptsetup config /dev/disk/by-partlabel/disk-${group}-${name} --label "${name}"
      ${postCreate}
    '';
  };
in if entireDisk then body else {
  inherit size priority;
  content = body;
}
