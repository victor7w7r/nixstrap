let
  winmod = import ../filesystems/windows.nix;

  esp = (import ../lib/esp.nix) { };
  msr = winmod.msr { };
  emergency = (import ../lib/emergency.nix) { };
  recovery = winmod.recovery { };
  win = winmod.win { size = "100%"; };
  cryptsys = (import ../lib/cryptsys.nix) { };

  fs = (import ../filesystems/fs.nix) { extraDirs = "/mnt/kvm /mnt/media"; };
  home = (import ../filesystems/home.nix);
  system = (import ../filesystems/system-btrfs.nix);
  kvm = (import ../filesystems/kvm.nix);

  partitions = { inherit esp emergency cryptsys; };
  satapartitions = { inherit msr recovery win; };
  lvs = {
    inherit
      fs
      home
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
