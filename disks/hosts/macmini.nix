let
  winmod = import ../lib/win.nix;

  esp = (import ../lib/esp.nix) { };
  msr = winmod.msr { };
  emergency = (import ../lib/emergency.nix) { };
  macos = {
    name = "macos";
    size = "110G";
  };
  recovery = winmod.recovery { };
  win = winmod.win { };

  cryptsys = (import ../filesystems/system.nix) { size = "90G"; };

  shared = (import ../filesystems/shared.nix) { };
  fstemp = (import ../filesystems/mock.nix) {
    extraDirs = "/mnt/kvm /mnt/media/nvmestorage /mnt/media/docs";
  };
  system = (import ../filesystems/system.nix) { };
  var = (import ../filesystems/var.nix);
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

  lvs = { inherit fstemp system; };
  storagelvs = { inherit var home; };
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
