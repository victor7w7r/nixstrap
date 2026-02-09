let
  partitions = {
    esp = (import ../lib/esp.nix) { };
    emergency = (import ../lib/emergency.nix) { isSolid = false; };
    swapcrypt = {
      name = "swapcrypt";
      size = "4G";
      priority = 3;
      content = {
        type = "swap";
        randomEncryption = true;
      };
    };
    systempv = (import ../lib/luks.nix) {
      allowDiscards = false;
      content = {
        vg = "vg0";
        type = "lvm_pv";
      };
      priority = 4;
      isForTest = true;
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
      device = "/dev/vda";
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
