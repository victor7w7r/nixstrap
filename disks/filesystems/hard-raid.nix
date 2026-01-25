(import ../lib/xfs.nix) {
  name = "hardraid";
  label = "hardraid";
  size = "100%";
  lvm_type = "thinlv";
  pool = "thinpool";
  mountpoint = "/run/media/hardraid";
  extraArgs = [
    "-l"
    "size=128,version=2"
    "-i"
    "size=512"
    "-d"
    "su=64k,sw=2"
  ];
}
