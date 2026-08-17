{ disko, lib, ... }:
{
  disko.btrfs = {
    emergency =
      {
        size ? "2G",
        priority ? 2,
      }:
      disko.btrfs.call {
        inherit size priority;
        name = "emergency";
        mountpoint = "/boot/emergency";
        mountOptions = disko.btrfs.mountOptions { };
      };

    shared =
      {
        name ? "shared",
      }:
      disko.btrfs.call {
        inherit name;
        size = "100%";
        priority = 100;
        subvolumes = {
          "@${name}" = {
            mountpoint = "/run/media/${name}";
            mountOptions = (disko.btrfs.mountOptions { });
          };
          "@snapshots" = {
            mountpoint = "/run/media/${name}/.snapshots";
            mountOptions = (disko.btrfs.mountOptions { });
          };
        };
      };

    mountOptions =
      {
        lowCompress ? false,
        extraOptions ? [ ],
      }:
      [
        "lazytime"
        "noatime"
        "nofail"
        "discard=async"
        "compress-force=zstd:${if lowCompress then "1" else "3"}"
      ]
      ++ extraOptions;

    subvolumes =
      {
        hasEtc ? false,
        hasPersist ? true,
      }:
      lib.mkMerge [
        (lib.mkIf hasEtc {
          "@etc" = {
            mountpoint = "/etc";
            mountOptions = (disko.btrfs.mountOptions { });
          };
        })
        (lib.mkIf hasPersist {
          "@persist" = {
            mountpoint = "/nix/persist";
            mountOptions = (disko.btrfs.mountOptions { });
          };
        })
        {
          "@nix" = {
            mountpoint = "/nix";
            mountOptions = (disko.btrfs.mountOptions { }) ++ [ "noacl" ];
          };
        }
      ];

    call =
      {
        name,
        size ? null,
        priority ? 3,
        isPartition ? true,
        mountpoint ? null,
        mountOptions ? [ ],
        subvolumes ? { },
      }:
      {
        inherit subvolumes mountpoint mountOptions;
        type = "btrfs";
        extraArgs = [
          "-f"
          "-L"
          "${name}"
        ];
      }
      |> (
        content:
        if isPartition then
          {
            inherit
              name
              size
              priority
              content
              ;
            type = "8300";
          }
        else
          content
      );
  };
}
