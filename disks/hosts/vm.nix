let
  partitions = {
    esp = (import ../lib/esp.nix) { };
    emergency = (import ../filesystems/emergency.nix) { isSolid = false; };
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
    "autodefrag"
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
  disko.devices.disk.main = {
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
}
