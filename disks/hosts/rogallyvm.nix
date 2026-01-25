let
  winmod = import ../lib/windows.nix;

  partitions = {
    msr = winmod.msr { };
    emergency = (import ../filesystems/emergency.nix) { priority = 3; };
    recovery = winmod.recovery { };
    win = winmod.win { };
    systempv = (import ../lib/luks-lvm.nix) {
      size = "90G";
      priority = 6;
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
    };
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
          partitions = {
            esp = (import ../lib/esp.nix) { };
          };
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
    lvm_vg.vg0 = {
      type = "lvm_vg";
      inherit lvs;
    };
  };
}
