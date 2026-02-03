let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
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
    games = (import ../filesystems/shared.nix) {
      name = "games";
      label = "games";
      mountContent = "games";
      mountSnap = "gamessnap";
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
  disko.devices.disk.main = {
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
}
