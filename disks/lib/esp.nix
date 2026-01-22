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
      "relatime"
      "fmask=0022"
      "dmask=0022"
      "umask=0077"
      "codepage=437"
      "iocharset=iso8859-1"
      "shortname=mixed"
      "nofail"
      "utf8"
      "errors=remount-ro"
    ];
  };
}
