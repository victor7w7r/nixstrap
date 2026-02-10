let
  partitions = {
    esp = (import ../lib/esp.nix) { };
    emergency = (import ../lib/emergency.nix) { isSolid = false; };
    systempv = (import ../lib/luks-lvm.nix) {
      allowDiscards = false;
      content = {
        vg = "vg0";
        type = "lvm_pv";
      };
      priority = 3;
      isForTest = true;
    };
  };
  lvs = {
    syscrypt = (import ../lib/btrfs.nix) {
      name = "system";
      size = "90G";
      subvolumes = (import ../lib/subvolumes-btrfs.nix) { };
    };
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
    lvm_vg."vg0" = {
      type = "lvm_vg";
      inherit lvs;
    };
  };
}
