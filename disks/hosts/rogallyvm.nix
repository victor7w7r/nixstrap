let
  winmod = import ../lib/win.nix;

  esp = (import ../lib/esp.nix) { };
  msr = winmod.msr { };
  emergency = (import ../lib/emergency.nix) { priority = 3; };
  recovery = winmod.recovery { };
  win = winmod.win { };
  cryptsys = (import ../lib/cryptsys.nix) {
    size = "90G";
    priority = 6;
  };

  fs = (import ../filesystems/fs.nix) { extraDirs = "/mnt/games /mnt/home"; };
  system = (import ../filesystems/system-xfs.nix) {
    extraDirs = "/mnt/home /mnt/.nix/home";
    extraBinds = "mount --bind /mnt/.nix/home /mnt/home";
  };

  partitions = {
    inherit
      msr
      emergency
      recovery
      win
      cryptsys
      ;
  };

  lvs = { inherit fs system; };
in
{
  disko.devices = {
    disk = {
      esp = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = { inherit esp; };
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
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        inherit lvs;
      };
    };
  };
}
