let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    emergency = (import ../filesystems/emergency.nix) { priority = 3; };
    recovery = winmod.recovery { };
    win = winmod.win { };
    systempv = (import ../lib/lvm.nix) {
      size = "100G";
      priority = 6;
    };
    games = (import ../filesystems/shared.nix) {
      name = "games";
      mountContent = "games";
      mountSnap = "snapgames";
    };
  };

  lvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    rootfs = (import ../filesystems/rootfs.nix) { extraDirs = "/mnt/games /mnt/home"; };
    system = (import ../filesystems/system-xfs.nix) {
      hasHome = true;
      hasStore = true;
      size = "90G";
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
    lvm_vg.vg0 = {
      type = "lvm_vg";
      inherit lvs;
    };
  };
}
