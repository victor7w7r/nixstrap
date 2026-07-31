{ disko, inputs, ... }:
{
  den.aspects.handheld.disks.nixos = {
    imports = [ inputs.disko.nixosModules.disko ];
    fileSystems = {
      "/nix/persist".neededForBoot = true;
      "/etc".neededForBoot = true;
    };
    disko.devices.disk = with disko; {
      root = disk.root { };
      main = disk.gpt {
        device = "nvme0n1";
        partitions = {
          esp = esp.call { };
          msr = win.msr { };
          emergency = btrfs.emergency { priority = 3; };
          recovery = win.recovery { };
          win = win.call { };
          swapcrypt = luks.call {
            name = "swapcrypt";
            size = "14G";
            content = swap.call { };
            priority = 6;
          };
          system = btrfs.call {
            name = "system";
            size = "110G";
            priority = 7;
            subvolumes = btrfs.subvolumes { hasEtc = true; };
          };
          games = btrfs.shared { name = "games"; };
        };
      };
    };
  };
}
