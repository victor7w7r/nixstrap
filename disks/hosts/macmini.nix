let
  boot = import ../modules/boot.nix;
  winmod = import ../modules/win.nix;
  linux = import ../modules/linux.nix;

  esp = boot.esp { };
  msr = winmod.msr { };
  vault = boot.vault { };
  macos = {
    name = "macos";
    size = "110G";
  };
  recovery = winmod.recovery { };
  win = winmod.win { };
  cryptsys = linux.cryptsys { size = "90G"; };
  shared = linux.shared { };

  fstemp = linux.mockpart {
    extraDirs = "/mnt/kvm /mnt/media/nvmestorage /mnt/media/docs";
  };
  system = linux.syspart { };

  var = linux.varpart { };
  home = linux.homepart { size = "100%"; };

  partitions = {
    inherit
      esp
      msr
      vault
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
