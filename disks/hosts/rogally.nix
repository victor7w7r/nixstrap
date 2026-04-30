let
  winmod = import ../lib/windows.nix;

  partitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    emergency = (import ../lib/emergency.nix) { priority = 3; };
    recovery = winmod.recovery { };
    win = winmod.win { };
    swapcrypt = (import ../lib/luks.nix) {
      name = "swapcrypt";
      size = "14G";
      group = "main";
      content = (import ../lib/swap.nix) { };
      priority = 5;
    };
    system = (import ../lib/bcachefs.nix).partition {
      name = "system";
      size = "110G";
      priority = 6;
    };
    games = (import ../lib/shared.nix) {
      name = "games";
      mountContent = "games";
      mountSnap = "gamessnap";
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
    bcachefs_filesystems = {
      broot = (import ../lib/bcachefs.nix).filesystem {
        uuid = "f9d26816-07f4-42cf-a9ae-f698ff56b172";
        passwordFile = "/tmp/key.txt";
        subvolumes = {
          "subvolumes/nix" = {
            mountpoint = "/nix";
            mountOptions = [
              "nodiratime"
              "noatime"
              "discard"
            ];
          };
          "subvolumes/persist" = {
            mountpoint = "/nix/persist";
            mountOptions = [
              "nodiratime"
              "noatime"
              "discard"
            ];
          };
        };
      };
    };
  };
}
