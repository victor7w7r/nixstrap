{ disko, ... }:
{
  den.aspects.phone.disks.nixos.disko.devices = with disko; {
    disk = {
      root = ephemeral.root { };
      main = disk.gpt {
        device = "nvme0n1";
        partitions.system = f2fs.call {
          name = "NIXOS_SYSTEM";
          size = "100%";
          mountpoint = "/nix";
          priority = 1;
        };
      };
    };
  };
}
