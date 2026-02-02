let
  mountOptions = [
    "lazytime"
    "noatime"
    "autodefrag"
    "compress=zstd"
  ];

  partitions = {
    esp = (import ../lib/esp.nix) { };
    emergency = (import ../filesystems/emergency.nix) { isSolid = false; };
    systempv = (import ../lib/luks.nix) {
      allowDiscards = false;
      content = {
        vg = "vg0";
        type = "lvm_pv";
      };
      size = "100G";
      isForTest = true;
    };
  };

  lvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    swapcrypt = {
      name = "swapcrypt";
      lvmPool = "thinpool";
      size = "4G";
      content.type = "swap";
    };
    syscrypt = (import ../lib/btrfs.nix) {
      name = "system";
      label = "system";
      lvmPool = "thinpool";
      size = "90G";
      inherit subvolumes;
    };
  };

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
