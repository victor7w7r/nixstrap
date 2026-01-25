let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    emergency = (import ../filesystems/emergency.nix) { priority = 3; };
    systempv = (import ../lib/luks-lvm.nix) { };
  };

  lvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    rootfs = (import ../filesystems/rootfs.nix) { extraDirs = "/mnt/home"; };
    system = (import ../filesystems/system-xfs.nix) {
      hasHome = true;
      hasStore = true;
      size = "200G";
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
