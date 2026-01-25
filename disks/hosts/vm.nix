let
  partitions = {
    esp = (import ../lib/esp.nix) { };
    emergency = (import ../filesystems/emergency.nix) { };
    systempv = (import ../lib/luks-lvm.nix) { };
  };

  lvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    rootfs = (import ../filesystems/rootfs.nix) { };
    system = (import ../filesystems/system-btrfs.nix) {
      hasHome = true;
      size = "20G";
    };
    store = (import ../filesystems/store-only) { };
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
    lvm_vg.vg0 = {
      type = "lvm_vg";
      inherit lvs;
    };
  };
}
