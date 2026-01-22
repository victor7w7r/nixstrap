let
  winmod = import ../filesystems/windows.nix;

  esp = (import ../lib/esp.nix) { };
  emergency = (import ../lib/emergency.nix) { };
  cryptsys = (import ../filesystems/system.nix) { };

  msr = winmod.msr { };
  recovery = winmod.recovery { };
  win = winmod.win { size = "100%"; };

  fstemp = (import ../filesystems/mock.nix) { extraDirs = "/mnt/kvm /mnt/media"; };
  home = (import ../filesystems/home.nix);
  var = (import ../filesystems/var.nix);
  system = (import ../filesystems/system.nix) { size = "70G"; };
  kvm = (import ../filesystems/kvm.nix);

  partitions = { inherit esp emergency cryptsys; };
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
