let
  winmod = import ../lib/windows.nix;

  esp = (import ../lib/esp.nix) { };
  msr = winmod.msr { };
  emergency = (import ../lib/emergency.nix) { priority = 3; };
  recovery = winmod.recovery { };
  win = winmod.win { };
  cryptsys = (import ../lib/cryptsys.nix) {
    size = "90G";
    priority = 6;
  };
  games = (import ../filesystems/shared.nix) {
    name = "games";
    mountContent = "/games";
    mountSnap = "/games.snap";
  };

  fs = (import ../filesystems/fs.nix) { extraDirs = "/mnt/games /mnt/home"; };
  system = (import ../filesystems/system-xfs.nix) {
    extraDirs = "/mnt/games /mnt/home /mnt/.nix/home";
    extraBinds = "mount --bind /mnt/.nix/home /mnt/home";
  };

  partitions = {
    inherit
      esp
      msr
      emergency
      recovery
      win
      cryptsys
      games
      ;
  };

  lvs = { inherit fs system; };
in
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        inherit partitions;
      };
    };
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        inherit lvs;
      };
    };
  };
}
