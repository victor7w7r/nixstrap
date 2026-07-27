{ disko, ... }:
{
  disko.disk = {
    constants = {
      partlabel = "disk/by-partlabel";
      id = "disk/by-id";
    };

    gpt =
      {
        device,
        partitions,
      }:
      {
        type = "disk";
        device = "/dev/${device}";
        content = {
          type = "gpt";
          inherit partitions;
        };
      };

    lvm =
      {
        device,
        num ? 0,
      }:
      {
        type = "disk";
        device = "/dev/${device}";
        content = {
          vg = "vg${toString num}";
          type = "lvm_pv";
        };
      };

    root =
      { }:
      {
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

    mdraid =
      {
        device,
        name ? "raid0",
      }:
      {
        type = "disk";
        device = "/dev/${disko.constants.id}/${device}";
        content = {
          type = "mdraid";
          inherit name;
        };
      };
  };
}
