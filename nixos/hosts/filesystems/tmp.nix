let
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
  "/tmp" = tmpMap { };
  "/var/tmp" = tmpMap { depends = [ "/var" ]; };
  "/var/cache" = tmpMap { depends = [ "/var" ]; };
}
