let
  esp = (import ../lib/esp.nix) { };
  emergency = (import ../lib/emergency.nix) { };
  cryptsys = (import ../lib/cryptsys.nix) { };

  fs = (import ../filesystems/fs.nix) { };
  home = (import ../filesystems/home.nix);
  system = (import ../filesystems/system-btrfs.nix) { };

  partitions = { inherit esp emergency cryptsys; };
  lvs = { inherit fs home system; };
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
