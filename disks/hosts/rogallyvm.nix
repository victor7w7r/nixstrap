let
  boot = import ../modules/boot.nix;
  winmod = import ../modules/win.nix;
  linux = import ../modules/linux.nix;

  esp = boot.esp { };
  msr = winmod.msr { };
  vault = boot.vault { priority = 3; };
  recovery = winmod.recovery { };
  win = winmod.win { };
  cryptsys = linux.cryptsys {
    size = "90G";
    priority = 6;
  };

  fstemp = linux.mockpart { extraDirs = "/mnt/home"; };
  var = linux.varpart;
  system = linux.syspart {
    extraDirs = "/mnt/home /mnt/.nix/home";
    extraBinds = "mount --bind /mnt/.nix/home /mnt/home";
  };

  partitions = {
    inherit
      msr
      vault
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
        device = "/dev/sda1";
        content = {
          type = "gpt";
          partitions = { inherit esp; };
        };
      };
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
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
