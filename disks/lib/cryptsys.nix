{
  size ? "100%",
  name ? "cryptsystem",
  keyFile ? "/tmp/pass.key",
  index ? "0",
  group ? "vg",
  priority ? 3,
}:
{
  inherit size priority;
  content = {
    type = "luks";
    inherit name;
    settings = {
      inherit keyFile;
      allowDiscards = true;
    };
    content = {
      type = "lvm_pv";
      vg = "${group}${index}";
    };
    preCreateHook = ''
      dd if=/dev/urandom of=/root/nixstrap/syskey.key bs=1 count=64
      chmod 0400 /root/nixstrap/syskey.key
      git config --global user.email "nixos@flake.com" && \
      git config --global user.name "nixosflake" && \
      git config --global --add safe.directory /root/nixstrap && \
      cd /root/nixstrap && git add . && git commit -m "Add Key"
    '';
    postCreateHook = ''
      cryptsetup config /dev/disk/by-partlabel/disk-main-cryptsys --label "SYSTEM"
      cryptsetup luksAddKey /dev/disk/by-partlabel/disk-main-cryptsys /root/nixstrap/syskey.key -d /tmp/pass.key
    '';
  };
}
