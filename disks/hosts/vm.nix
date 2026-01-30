let
  esp = (import ../lib/esp.nix) { };
  emergency = (import ../filesystems/emergency.nix) { };
  subvolumes = {
    "@" = {
      mountpoint = "/";
      mountOptions = [ "compress=zstd" ];
    };
    "@nix" = {
      mountpoint = "/nix";
      mountOptions = [
        "compress=zstd"
        "noacl"
      ];
    };
    "@persist" = {
      mountpoint = "/nix/persist";
      mountOptions = [ "compress=zstd" ];
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
        partitions = {
          inherit esp emergency;
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
              isSolid = false;
              inherit subvolumes;
            };
          };
        };
      };
    };
  };
}
