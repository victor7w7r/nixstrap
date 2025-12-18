{
  ext4Options = [
    "noatime"
    "lazytime"
    "nobarrier"
    "nodiscard"
    "commit=120"
  ];
  fatOptions = [
    "relatime"
    "fmask=0022"
    "dmask=0022"
    "umask=0077"
    "nofail"
  ];
  btrfsOptions = [
    "noatime"
    "lazytime"
    "nodiscard"
    "compress-force=zstd:3"
    "commit=60"
    "nofail"
  ];
}
