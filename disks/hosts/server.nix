let
  zfs-part =
    {
      priority,
      pool ? "zroot",
      size ? "100%",
    }:
    {
      inherit size priority;
      content = {
        type = "zfs";
        inherit pool;
      };
    };

  hdd-init =
    {
      device,
      pool ? "zcloud",
    }:
    {
      type = "disk";
      device = "/dev/disk/by-id/${device}";
      content = {
        type = "zfs";
        inherit pool;
      };
    };

  mmcpartitions = {
    esp = (import ../lib/esp.nix) { };
    sysetc = (import ../lib/f2fs.nix) {
      label = "sysetc";
      name = "sysetc";
      size = "2G";
      mountpoint = "/nix/persist/etc";
      isIsolated = true;
      priority = 2;
    };
    shared = (import ../lib/f2fs.nix) {
      label = "shared";
      name = "shared";
      size = "100%";
      mountpoint = "/nix/persist/shared";
      isIsolated = true;
      priority = 3;
    };
  };

  nvmepartitions = {
    emergency = (import ../filesystems/emergency.nix) { priority = 1; };
    swapcrypt = {
      name = "swapcrypt";
      size = "8G";
      priority = 2;
      content = {
        type = "swap";
        randomEncryption = true;
      };
    };
    syslog = zfs-part {
      size = "2G";
      priority = 3;
    };
    cloudlog = zfs-part {
      size = "16G";
      pool = "zcloud";
      priority = 4;
    };
    sysspecial = zfs-part {
      size = "40G";
      priority = 5;
    };
    cloudspecial = zfs-part {
      size = "100G";
      pool = "zcloud";
      priority = 6;
    };
    syscache = zfs-part {
      size = "78G";
      priority = 7;
    };
    cloudcache = zfs-part {
      priority = 8;
      size = "120G";
      pool = "zcloud";
    };
  };
in
{
  disko.devices = {
    disk = {
      emmc = {
        type = "disk";
        device = "/dev/mmcblk0";
        content = {
          type = "gpt";
          partitions = mmcpartitions;
        };
      };
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = nvmepartitions;
        };
      };
      cloud1 = hdd-init {
        device = "ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X";
      };
      cloud2 = hdd-init {
        device = "ata-MM1000GBKAL_9XG3YGXQ";
      };
      cloud3 = hdd-init {
        device = "ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H";
      };
      cloud4 = hdd-init {
        device = "ata-TOSHIBA_MQ01ABD100_46G8SH1BST";
      };
      sysroot = hdd-init {
        device = "ata-ST500LT012-1DG142_S3PMCMHT";
        pool = "zroot";
      };
    };
    zpool =
      let
        partlabel = "/dev/disk/by-partlabel";
        idpart = "/dev/disk/by-id";
        emptySnapshot =
          name: "zfs list -t snapshot -H -o name | grep -E '^${name}@empty$' || zfs snapshot ${name}@empty";
      in
      {
        zroot = {
          type = "zpool";
          options = {
            ashift = "12";
            autotrim = "on";
          };
          rootFsOptions = {
            acltype = "posixacl";
            atime = "off";
            mountpoint = "none";
            compression = "zstd";
            canmount = "off";
            checksum = "edonr";
            normalization = "formD";
            dnodesize = "auto";
            xattr = "sa";
          };
          postCreateHook = ''
            zfs set keylocation="prompt" $name;
            if ! zfs list -t snap zroot/local/root@empty; then
                zfs snapshot zroot/local/root@empty
            fi
          '';
          mode.topology = {
            type = "topology";
            vdev = [ { members = [ "sysroot" ]; } ];
            log = [ { members = [ "${partlabel}/disk-nvme-syslog" ]; } ];
            special = [ { members = [ "${partlabel}/disk-nvme-sysspecial" ]; } ];
            cache = [ "${partlabel}/disk-nvme-syscache" ];
          };
          datasets = {
            "local/root" = {
              type = "zfs_fs";
              options = {
                atime = "off";
                canmount = "on";
                compression = "zstd";
              };
              mountpoint = "/";
              postCreateHook = ''
                zfs snapshot zroot/local/root@empty;
                zfs snapshot zroot/local/root@lastboot;
              '';
            };
            "local/nix" = {
              type = "zfs_fs";
              options.mountpoint = "legacy";
              mountpoint = "/nix";
              options = {
                atime = "off";
                canmount = "on";
                compression = "zstd";
                "com.sun:auto-snapshot" = "true";
              };
              postCreateHook = emptySnapshot "zroot/local/nix";
            };
            "local/persist" = {
              type = "zfs_fs";
              mountpoint = "/nix/persist";
              options = {
                mountpoint = "legacy";
                atime = "off";
                "com.sun:auto-snapshot" = "true";
                encryption = "aes-256-gcm";
                keyformat = "passphrase";
                keylocation = "prompt";
              };
              postCreateHook = emptySnapshot "zroot/local/persist";
            };
            "local/vm" = {
              type = "zfs_fs";
              options = {
                mountpoint = "legacy";
                atime = "off";
                recordsize = "64K";
                "com.sun:auto-snapshot" = "true";
                encryption = "aes-256-gcm";
                keyformat = "passphrase";
                keylocation = "prompt";
              };
              mountpoint = "/nix/persist/var/lib/libvirt/images";
              postCreateHook = emptySnapshot "zroot/local/vm";
            };
          };
        };
        zcloud = {
          type = "zpool";
          rootFsOptions = {
            mountpoint = "none";
            compression = "zstd";
            acltype = "posixacl";
            xattr = "sa";
          };
          mode.topology = {
            type = "topology";
            vdev = [
              {
                mode = "raidz1";
                members = [
                  "${idpart}/ata-WDC_WD10SPZX-75Z10T1_WXB1A281J35X"
                  "${idpart}/ata-MM1000GBKAL_9XG3YGXQ"
                  "${idpart}/ata-WDC_WD10SPZX-24Z10_WD-WXU1E887FE3H"
                  "${idpart}/ata-TOSHIBA_MQ01ABD100_46G8SH1BST"
                ];
              }
            ];
            log = [ { members = [ "${partlabel}/disk-nvme-cloudlog" ]; } ];
            special = [ { members = [ "${partlabel}/disk-nvme-cloudspecial" ]; } ];
            cache = [ "${partlabel}/disk-nvme-cloudcache" ];
          };
          options.ashift = "12";
          datasets."local/cloud" = {
            type = "zfs_fs";
            mountpoint = "/nix/persist/cloud";
            options = {
              mountpoint = "legacy";
              atime = "off";
              encryption = "aes-256-gcm";
              keyformat = "passphrase";
              keylocation = "prompt";
              "com.sun:auto-snapshot" = "true";
            };
            postCreateHook = emptySnapshot "zcloud/local/cloud";
          };
        };
      };
  };
}
