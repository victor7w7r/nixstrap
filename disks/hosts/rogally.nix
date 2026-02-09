let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    emergency = (import ../lib/emergency.nix) { priority = 3; };
    recovery = winmod.recovery { };
    win = winmod.win { };
    systempv = (import ../lib/luks.nix) {
      size = "100G";
      content = {
        vg = "vg0";
        type = "lvm_pv";
      };
      priority = 6;
    };
    games = (import ../lib/shared.nix) {
      name = "games";
      label = "games";
      mountContent = "games";
      mountSnap = "gamessnap";
    };
  };

  syscrypt = (import ../lib/btrfs.nix) {
    name = "system";
    label = "system";
    lvmPool = "thinpool";
    size = "90G";
    subvolumes = (import ../lib/subvolumes-btrfs.nix) { };
  };
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
  }
  // (import ../lib/lvs.nix) {
    content = syscrypt;
  };
}
