let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    emergency = (import ../lib/emergency.nix) { priority = 3; };
    systempv = (import ../lib/luks.nix) {
      size = "100G";
      content = {
        vg = "vg0";
        type = "lvm_pv";
      };
      priority = 4;
    };
  };

  syscrypt = (import ../lib/btrfs.nix) {
    name = "system";
    label = "system";
    lvmPool = "thinpool";
    size = "200G";
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
