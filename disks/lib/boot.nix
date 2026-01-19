rec {
  fatOptions = [
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

  esp =
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
        mountOptions = fatOptions;
      };
    };

  vault =
    {
      size ? "2G",
      name ? "Vault",
      mountpoint ? "/boot/vault",
      priority ? 2,
    }:
    {
      inherit name size priority;
      type = "0700";
      content = {
        type = "filesystem";
        format = "vfat";
        extraArgs = [
          "-F32"
          "-n"
          "Vault"
        ];
        inherit mountpoint;
        mountOptions = fatOptions;
      };
    };
}
