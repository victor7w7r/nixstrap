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
          syscrypt = (import ../lib/luks.nix) {
            allowDiscards = false;
            content = {
              swap = {
                size = "4G";
                content = {
                  type = "swap";
                  randomEncryption = true;
                  priority = 1;
                };
              };
              system = (import ../lib/btrfs.nix) {
                name = "system";
                size = "100%";
                label = "system";
                type = "8300";
                priority = 2;
                isSolid = false;
                inherit subvolumes;
              };
            };
          };
        };
      };
    };
  };
}
