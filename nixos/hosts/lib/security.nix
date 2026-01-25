{ self, ... }:
{
  system = {
    device = "/dev/disk/by-label/SYSTEM";
    keyFile = "/syskey.key";
    allowDiscards = true;
    preLVM = true;
  };
  secrets = {
    "/syskey.key" = builtins.path { path = "${self}/syskey.key"; };
  };
}
