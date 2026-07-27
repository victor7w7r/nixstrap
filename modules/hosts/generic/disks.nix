{ disko, ... }:
{
  den.aspects.generic.disks.nixos.disko.devices.disk = with disko; {
    root = disk.root { };
    main = disk.gpt {
      device = "vda";
      partitions = {
        esp = esp.call { };
        system = btrfs.call {
          name = "system";
          size = "100%";
          priority = 2;
          subvolumes = disko.btrfs.subvolumes { hasEtc = true; };
        };
      };
    };
  };
}
