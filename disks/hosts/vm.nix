let
  esp = (import ../lib/esp.nix) { };
  emergency = (import ../lib/emergency.nix) { };
  cryptsys = (import ../filesystems/system.nix) { };

  fstemp = (import ../filesystems/mock.nix) { };
  home = (import ../filesystems/home.nix);
  var = (import ../filesystems/var.nix);
  system = (import ../filesystems/system.nix) { };

  partitions = { inherit esp emergency cryptsys; };
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
