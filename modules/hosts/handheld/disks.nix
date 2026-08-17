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
          system = luks.call {
            name = "system";
            size = "110G";
            enrollFido2 = true;
            device = "${disk.constants.partlabel}/disk-nvme-system";
            priority = 7;
            content = btrfs.call {
              entireDisk = false;
              subvolumes = btrfs.subvolumes { hasEtc = true; };
            };
          };
          games = btrfs.shared { name = "games"; };
        };
      };
    };
  };
}
