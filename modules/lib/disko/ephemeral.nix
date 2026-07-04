{ disko, ... }:
{
  disko.ephemeral.root = {
    type = "disk";
    device = "/dev/zram1";
    content = {
      type = "filesystem";
      format = "ext4";
      mountpoint = "/";
      mountOptions = [
        "noatime"
        "x-systemd.device-timeout=0"
      ];
    };
  };
}
