let
  nixBind =
    {
      neededForBoot ? true,
      dir,
    }:
    {
      device = "/.nix/${dir}";
      options = [ "bind" ];
      inherit neededForBoot;
    };
in
{
  hasHome ? false,
  hasStore ? false,
}:
{
  "/etc" = nixBind { dir = "etc"; };
  "/root" = nixBind {
    dir = "root";
    neededForBoot = false;
  };
  "/.nix" = {
    device = "/dev/mapper/vg0-system";
    fsType = "xfs";
    neededForBoot = true;
    options = [
      "attr2"
      "noatime"
      "lazytime"
      "nodiscard"
      "logbsize=256k"
      "inode64"
    ];
  };

}
// (
  if hasHome then
    {
      "/home" = nixBind { dir = "home"; };
    }
  else
    { }
)
// (
  if hasStore then
    {
      "/nix" = nixBind { dir = "nix"; };
    }
  else
    { }
)
