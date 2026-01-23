let
  winmod = import ../lib/win.nix;
  esp = (import ../lib/esp.nix) { };
  msr = winmod.msr { };
  emergency = (import ../lib/emergency.nix) { priority = 3; };
  recovery = winmod.recovery { };
  macos = {
    name = "macos";
    size = "110G";
    priority = 5;
  };
  win = winmod.win { priority = 6; };
  cryptsys = (import ../lib/cryptsys.nix) {
    size = "90G";
    priority = 7;
  };
  shared = (import ../filesystems/shared.nix) { };

  fs = (import ../filesystems/mock.nix) {
    extraDirs = "/mnt/kvm /mnt/media/nvmestorage /mnt/media/docs";
  };
  system = (import ../filesystems/system-btrfs.nix) { };
  home = (import ../filesystems/home.nix) { size = "100%"; };

  partitions = {
    inherit
      esp
      msr
      emergency
      macos
      recovery
      win
      cryptsys
      shared
      ;
  };

  storagepartitions = {
    storage = cryptsys {
      name = "cryptstorage";
      index = "1";
      group = "vg";
    };
  };

  lvs = { inherit fs system; };
  storagelvs = { inherit home; };
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          inherit partitions;
        };
      };
      storage = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = storagepartitions;
        };
      };
    };
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        inherit lvs;
      };
      vg1 = {
        type = "lvm_vg";
        lvs = storagelvs;
      };
    };
  };
}
