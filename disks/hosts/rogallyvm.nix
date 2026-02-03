let
  winmod = import ../lib/windows.nix;

  partitions = {
    msr = winmod.msr { };
    emergency = (import ../filesystems/emergency.nix) { priority = 3; };
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

  lvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    syscrypt = (import ../lib/btrfs.nix) {
      name = "system";
      label = "system";
      lvmPool = "thinpool";
      size = "90G";
      inherit subvolumes;
    };
  };

  mountOptions = [
    "lazytime"
    "noatime"
    "discard=async"
    "compress=zstd"
  ];

  subvolumes = {
    "@" = {
      mountpoint = "/";
      inherit mountOptions;
    };
    "@nix" = {
      mountpoint = "/nix";
      mountOptions = mountOptions ++ [ "noacl" ];
    };
    "@persist" = {
      mountpoint = "/nix/persist";
      inherit mountOptions;
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
    lvm_vg.vg0 = {
      type = "lvm_vg";
      inherit lvs;
    };
  };
}
