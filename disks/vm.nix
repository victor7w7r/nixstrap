let
  boot = import ./common/boot.nix;
  linux = import ./common/linux.nix;

  esp = boot.esp { };
  vault = boot.vault { };
  cryptsys = linux.cryptsys { };

  fstemp = linux.mockpart { };
  home = linux.homepart { };
  var = linux.varpart;
  system = linux.syspart { };

  partitions = { inherit esp vault cryptsys; };
  lvs = {
    inherit
      fstemp
      home
      var
      system
      ;
  };
in
{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/vda";
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
