let
  boot = import ./common/boot.nix;
  winmod = import ./common/win.nix;
  linux = import ./common/linux.nix;

  esp = boot.esp { };
  vault = boot.vault { };
  cryptsys = linux.cryptsys { };

  msr = winmod.msr { };
  recovery = winmod.recovery { };
  win = winmod.win { size = "100%"; };

  fstemp = linux.mockpart { extraDirs = "/mnt/kvm /mnt/media"; };
  home = linux.homepart { };
  var = linux.varpart;
  system = linux.syspart { size = "70G"; };
  kvm = linux.kvmpart;

  partitions = { inherit esp vault cryptsys; };
  satapartitions = { inherit msr recovery win; };
  lvs = {
    inherit
      fstemp
      home
      var
      system
      kvm
      ;
  };
in
{
  disko.devices = {
    disk = {
      stick = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          inherit partitions;
        };
      };
      sata = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = satapartitions;
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
