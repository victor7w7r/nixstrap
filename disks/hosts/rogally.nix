let
  winmod = import ../filesystems/windows.nix;

  esp = (import ../lib/esp.nix) { };
  msr = winmod.msr { };
  emergency = (import ../lib/emergency.nix) { priority = 3; };
  recovery = winmod.recovery { };
  win = winmod.win { };

  cryptsys = (import ../filesystems/system.nix) {
    size = "90G";
    priority = 6;
  };
  games = (import ../filesystems/shared.nix) {
    name = "games";
    mountpoint = "/games";
  };
  fstemp = (import ../filesystems/mock.nix) { extraDirs = "/mnt/games /mnt/home"; };
  var = (import ../filesystems/var.nix);
  system = (import ../filesystems/system.nix) {
    extraDirs = "/mnt/games /mnt/home /mnt/.nix/home";
    extraBinds = "mount --bind /mnt/.nix/home /mnt/home";
  };

  partitions = {
    inherit
      esp
      msr
      emergency
      recovery
      win
      cryptsys
      games
      ;
  };

  lvs = { inherit fstemp var system; };
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
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        inherit lvs;
      };
    };
  };
}
