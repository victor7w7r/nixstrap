{
  size ? "300M",
}:
{
  inherit size;
  name = "EFI";
  type = "EF00";
  priority = 1;
  content = {
    type = "filesystem";
    format = "vfat";
    mountpoint = "/boot";
    extraArgs = [
      "-F32"
      "-n"
      "EFI"
    ];
    mountOptions = [
      "lazytime"
      "noatime"
      "umask=0077"
      "dmask=0077"
      "codepage=437"
      "iocharset=ascii"
      "shortname=mixed"
    ];
  };
}
