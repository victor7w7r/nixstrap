let
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
(import ../lib/disko-main.nix) {
  device = "vda";
  partitions = {
    esp = (import ../lib/esp.nix) { };
    emergency = (import ../filesystems/emergency.nix) { isSolid = false; };
    swapcrypt = (import ../lib/luks.nix) {
      allowDiscards = false;
      priority = 1;
      name = "swapcrypt";
      size = "4G";
      content = {
        type = "swap";
        randomEncryption = true;
      };
    };
    syscrypt = (import ../lib/luks.nix) {
      allowDiscards = false;
      priority = 2;
      content = (import ../lib/btrfs.nix) {
        label = "system";
        isIsolated = true;
        inherit subvolumes;
      };
    };
  };
}
