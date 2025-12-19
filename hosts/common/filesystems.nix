{
  homeDisk ? "/dev/mapper/vg0-home",
  varDisk ? "/dev/mapper/vg0-var",
}:
let
  options = import ./options.nix;
  nixBind =
    {
      dir,
      neededForBoot ? true,
    }:
    {
      device = "/.nix/${dir}";
      options = [ "bind" ];
      inherit neededForBoot;
    };
  tmpMap =
    {
      depends ? [ ],
    }:
    {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=1777" ];
      inherit depends;
    };
in
{
  "/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    neededForBoot = true;
    options = [ "mode=1777" ];
  };
  "/.nix" = {
    device = "/dev/mapper/vg0-system";
    fsType = "ext4";
    neededForBoot = true;
    options = options.ext4Options;
  };
  "/nix" = nixBind { dir = "nix"; };
  "/etc" = nixBind { dir = "etc"; };
  "/root" = nixBind {
    dir = "root";
    neededForBoot = false;
  };
  "/boot" = {
    device = "/dev/disk/by-partlabel/disk-main-EFI";
    fsType = "vfat";
    options = options.fatOptions;
  };
  "/boot/vault" = {
    device = "/dev/disk/by-partlabel/disk-main-vault";
    fsType = "vfat";
    options = options.fatOptions;
    depends = [ "/boot" ];
  };

  "/var" = {
    device = varDisk;
    fsType = "ext4";
    options = options.ext4Options;
  };

  "/tmp" = tmpMap { };
  "/var/tmp" = tmpMap { depends = [ "/var" ]; };
  "/var/cache" = tmpMap { depends = [ "/var" ]; };
}
// (
  if (homeDisk != "") then
    {
      "/home" = {
        device = homeDisk;
        fsType = "ext4";
        options = options.ext4Options;
      };
    }
  else
    { }
)
