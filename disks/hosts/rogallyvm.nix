let
  winmod = import ../lib/windows.nix;

  partitions = {
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
    disk = {
      esp = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions.esp = (import ../lib/esp.nix) { };
        };
      };
      main = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          inherit partitions;
        };
      };
    };
  }
  // (import ../lib/lvs.nix) {
    content = syscrypt;
  };
}
