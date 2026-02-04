let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    emergency = (import ../filesystems/emergency.nix) { priority = 3; };
    systempv = (import ../lib/lvm.nix) {
      content = {
        vg = "vg0";
        type = "lvm_pv";
      };
      priority = 4;
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
      size = "200G";
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
