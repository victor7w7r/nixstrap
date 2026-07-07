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
        num ? 0,
        device,
      }:
      {
        type = "disk";
        device = "/dev/${device}";
        content = {
          vg = "vg${num}";
          type = "lvm_pv";
        };
      };

    bcache-lvm =
      {
        num ? 0,
      }:
      {
        type = "disk";
        device = "/dev/bcache${num}";
        content = {
          vg = "vg${num}";
          type = "lvm_pv";
        };
      };

    vg =
      {
        num ? 0,
        lvs,
      }:
      {
        "vg${num}" = {
          type = "lvm_vg";
          inherit lvs;
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

    entire-luks =
      {
        name,
        device,
        postMount ? "",
        postCreate ? "",
        allowDiscards ? false,
      }:
      {
        type = "disk";
        inherit device;
        content = disko.luks.call {
          entireDisk = true;
          size = "100%";
          inherit device;
          inherit
            allowDiscards
            name
            postMount
            postCreate
            ;
        };
      };
  };
}
