(import ../lib/xfs.nix) {
  name = "cloudraid";
  label = "cloudraid";
  size = "100%";
  lvmPool = "thinpool";
  mountpoint = "/run/media/cloudraid";
  extraArgs = [
    "-l"
    "size=64"
    "-i"
    "size=256"
    "-d"
    "agcount=32"
  ];
}
