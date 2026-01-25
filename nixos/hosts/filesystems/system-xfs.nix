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
  dir ? "",
}:
{
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
  "/nix" = nixBind { dir = "nix"; };
  "/etc" = nixBind { dir = "etc"; };
  "/root" = nixBind {
    dir = "root";
    neededForBoot = false;
  };
}
// (
  if (dir != "") then
    {
      "/${dir}" = nixBind { inherit dir; };
    }
  else
    { }
)
