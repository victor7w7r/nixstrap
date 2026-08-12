{ disko, inputs, ... }:
{
  den.aspects.generic.disks.nixos = {
    imports = [ inputs.disko.nixosModules.disko ];
    disko.devices = with disko; {
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
  };
}
