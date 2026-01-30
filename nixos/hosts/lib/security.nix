{
  device ? "systempv",
  key ? "syskey.key",
  self,
  ...
}:
{
  system = {
    device = "/dev/disk/by-label/${device}";
    keyFile = "/syskey.key";
    allowDiscards = true;
    preLVM = true;
  };
  secrets = {
    "/${key}" = builtins.path { path = "${self}/${key}"; };
  };
}
