let
  boot = import ../modules/boot.nix;
  winmod = import ../modules/win.nix;
  linux = import ../modules/linux.nix;

  esp = boot.esp { };
  msr = winmod.msr { };
  vault = boot.vault { };
  recovery = winmod.recovery { };
  win = winmod.win { };
  cryptsys = linux.cryptsys { size = "90G"; };
  games = linux.shared {
    name = "games";
    mountpoint = "/games";
  };

  fstemp = linux.mockpart { extraDirs = "/mnt/games /mnt/home"; };
  var = linux.varpart;
  system = linux.syspart {
    extraDirs = "/mnt/games /mnt/home";
    extraBinds = "mount --bind /mnt/.nix/home /mnt/home";
  };

  partitions = {
    inherit
      esp
      msr
      vault
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
