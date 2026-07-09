{ disko, ... }:
{
  disko.bcachefs = {
    partition =
      {
        name,
        size,
        priority ? 5,
        filesystem ? "broot",
        extraOptions ? [ ],
      }:
      {
        inherit priority size name;
        type = "8300";
        content = {
          inherit filesystem;
          type = "bcachefs";
          label = name;
          extraFormatArgs = [
            "-f"
            "-L"
            name
            "--discard"
          ]
          ++ extraOptions;
        };
      };

    lvm =
      {
        num ? 0,
      }:
      disko.disk.lvm {
        inherit num;
        device = "/dev/bcache${toString num}";
      };

    subvolume =
      {
        name ? "",
        mountpoint,
        extraOptions ? [ ],
      }:
      {
        "subvolumes/${name}" = {
          inherit mountpoint;
          mountOptions = [
            "nodiratime"
            "noatime"
            "discard"
          ]
          ++ extraOptions;
        };
      };

    filesystem =
      {
        passwordFile ? null,
        mountpoint ? null,
        uuid ? null,
        extraFormatArgs ? [ ],
        subvolumes,
      }:
      {
        inherit
          passwordFile
          mountpoint
          subvolumes
          ;
        type = "bcachefs_filesystem";
        extraFormatArgs = [
          "--compression=zstd"
          "--background_compression=zstd"
          "--metadata_checksum=xxhash"
          "--data_checksum=xxhash"
          "--discard"
          "--str_hash=siphash"
          "--wide_macs"
          "--no_passphrase"
        ]
        ++ extraFormatArgs;
      }
      // (if uuid != null then { inherit uuid; } else { });
  };
}
