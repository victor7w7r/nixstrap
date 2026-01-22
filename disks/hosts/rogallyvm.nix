let
  winmod = import ../lib/win.nix;

  esp = (import ../lib/esp.nix) { };
  msr = winmod.msr { };
  emergency = (import ../lib/emergency.nix) { priority = 3; };
  recovery = winmod.recovery { };
  win = winmod.win { };

  cryptsys = (import ../filesystems/system.nix) {
    size = "90G";
    priority = 6;
  };
  fstemp = (import ../filesystems/mock.nix) { extraDirs = "/mnt/home"; };
  var = (import ../filesystems/var.nix);
  system = (import ../filesystems/system.nix) {
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

  lvs = { inherit fstemp var system; };
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
