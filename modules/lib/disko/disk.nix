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

    bcache =
      {
        num ? 0,
      }:
      disko.disk.lvm {
        inherit num;
        device = "/dev/bcache${toString num}";
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
