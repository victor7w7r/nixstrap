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
        device = "${disko.disk.constants.id}/${device}";
        content = disko.luks.call {
          entireDisk = true;
          size = "100%";
          device = "${disko.disk.constants.id}/${device}";
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
