let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    emergency = (import ../lib/emergency.nix) { priority = 3; };
    recovery = winmod.recovery { };
    win = winmod.win { };
    syscrypt = (import ../lib/luks-lvm.nix) {
      size = "100G";
      vg = "vg0";
      priority = 6;
    };
    games = (import ../lib/shared.nix) {
      name = "games";
      mountContent = "games";
      mountSnap = "gamessnap";
    };
  };

  lvs = {
    swapcrypt = (import ../lib/swap.nix) { };
    syscrypt = (import ../lib/btrfs.nix) {
      name = "system";
      size = "100%";
      subvolumes = (import ../lib/subvolumes-btrfs.nix) { };
    };
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
    lvm_vg."vg0" = {
      type = "lvm_vg";
      inherit lvs;
    };
  };
}
