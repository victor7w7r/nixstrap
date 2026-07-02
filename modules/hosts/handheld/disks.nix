{ disko, ... }:
{
  den.aspects.handheld.disks.nixos =
    let
      partitions = {
        esp = disko.esp.call { };
        msr = disko.win.msr { };
        emergency = disko.btrfs.emergency { priority = 3; };
        recovery = disko.win.recovery { };
        win = disko.win.call { };
        swapcrypt = disko.luks.call {
          name = "swapcrypt";
          size = "14G";
          content = disko.swap.call { };
          priority = 6;
        };
        system = disko.bcachefs.partition {
          name = "system";
          size = "110G";
          priority = 7;
        };
        /*
          games = disko.btrfs.shared {
            name = "games";
            mountContent = "games";
            mountSnap = "gamessnap";
          };
        */
      };
    in
    {

      swapDevices = [
        {
          device = "/dev/mapper/swapcrypt";
          discardPolicy = "both";
          options = [ "nofail" ];
        }
      ];

      fileSystems."/" = {
        device = "/dev/zram1";
        fsType = "ext4";
        neededForBoot = true;
        options = [
          "noatime"
          "x-systemd.device-timeout=0"
        ];
      };

      disko.devices = {
        disk.main = {
          type = "disk";
          device = "/dev/nvme0n1";
          content = {
            type = "gpt";
            inherit partitions;
          };
        };
        bcachefs_filesystems = {
          broot = disko.bcachefs.filesystem {
            uuid = "2564fcf6-551f-4358-b238-2fe638b1c159";
            subvolumes = {
              "subvolumes/nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "nodiratime"
                  "noatime"
                  "discard"
                ];
              };
              "subvolumes/persist" = {
                mountpoint = "/nix/persist";
                mountOptions = [
                  "nodiratime"
                  "noatime"
                  "discard"
                ];
              };
            };
          };
        };
      };
    };
}

/*
  let
    params = import ./lib/kernel-params.nix;
    boot = (import ./lib/boot.nix) { };
    helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
    kernelBuild = (pkgs.callPackage ../kernel) {
      inherit
        helpers
        host
        kernelData
        inputs
        ;
    };
    bcachefs = (import ./lib/bcachefs.nix);
    shared = (import ./lib/shared.nix) {
      sharedDir = "/run/media/games";
      partlabel = "games";
    };
  in

  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (shared) "/run/media/games";

    "/" = {
      device = "/dev/zram1";
      fsType = "ext4";
      neededForBoot = true;
      options = [
        "noatime"
        "x-systemd.device-timeout=0"
      ];
    };

    "/nix" = bcachefs {
      device = "/dev/disk/by-partlabel/disk-main-system";
      extraOptions = [
        "X-mount.subdir=subvolumes/nix"
        "x-systemd.device-timeout=300"
        "x-systemd.mount-timeout=300"
      ];
    };

    "/nix/persist" = bcachefs {
      device = "/dev/disk/by-partlabel/disk-main-system";
      extraOptions = [
        "X-mount.subdir=subvolumes/persist"
        "x-systemd.device-timeout=300"
        "x-systemd.mount-timeout=300"
      ];
      depends = [ "/nix" ];
    };
  };
*/
