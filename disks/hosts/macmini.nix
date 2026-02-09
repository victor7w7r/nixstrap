let
  winmod = import ../lib/windows.nix;
  zfs = import ../lib/zfs.nix;

  internalpartitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    recovery = winmod.recovery { priority = 3; };
    macos = {
      name = "macos";
      size = "110G";
      priority = 4;
    };
    sysetc = (import ../lib/btrfs.nix) {
      label = "sysetc";
      name = "sysetc";
      size = "2G";
      isSolid = true;
      mountpoint = "/nix/persist/etc";
      isIsolated = true;
      priority = 5;
    };
    win = winmod.win { priority = 6; };
    shared = (import ../lib/shared.nix) { };
  };

  ssdpartitions = {
    emergency = (import ../lib/emergency.nix) { priority = 1; };
    swapcrypt = {
      name = "swapcrypt";
      size = "32G";
      priority = 2;
      content = {
        type = "swap";
        randomEncryption = true;
      };
    };
    syslog = zfs.partition {
      size = "2G";
      priority = 3;
    };
    szlog = zfs.partition {
      size = "2G";
      priority = 4;
    };
    sysspecial = zfs.partition {
      size = "40G";
      priority = 5;
    };
    szspecial = zfs.partition {
      size = "40G";
      priority = 6;
    };
    syscache = zfs.partition {
      size = "70G";
      priority = 7;
    };
    szcache = zfs.partition {
      size = "70G";
      priority = 8;
    };
    szshared = zfs.partition {
      size = "180G";
      priority = 9;
    };
  };

  partlabel = "/dev/disk/by-partlabel";
  idpart = "/dev/disk/by-id";

  zroot = zfs.pool {
    isRoot = true;
    vdev = [ { members = [ "${idpart}/ata-TOSHIBA_MQ01ABD050V_34HES5WXS" ]; } ];
    log = [ { members = [ "${partlabel}/disk-ssd-syslog" ]; } ];
    special = [ { members = [ "${partlabel}/disk-ssd-sysspecial" ]; } ];
    cache = [ "${partlabel}/disk-ssd-syscache" ];
    datasets =
      zfs.dataset {
        isRoot = true;
        options = {
          canmount = "on";
          compression = "zstd";
        };
      }
      // zfs.dataset {
        name = "nix";
        mountpoint = "/nix";
        options = {
          canmount = "on";
          compression = "zstd";
          "com.sun:auto-snapshot" = "true";
        };
      }
      // zfs.dataset {
        name = "persist";
        mountpoint = "/nix/persist";
        options = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "prompt";
          "com.sun:auto-snapshot" = "true";
        };
      };
  };

  sz = zfs.pool {
    isRoot = true;
    vdev = [ { members = [ "${idpart}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK" ]; } ];
    log = [ { members = [ "${partlabel}/disk-ssd-szlog" ]; } ];
    special = [ { members = [ "${partlabel}/disk-ssd-szspecial" ]; } ];
    cache = [ "${partlabel}/disk-ssd-szcache" ];
    datasets = zfs.dataset {
      pool = "sz";
      name = "storage";
      mountpoint = "/nix/persist/storage";
      options = {
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";
        "com.sun:auto-snapshot" = "true";
      };
    };
  };
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = internalpartitions;
        };
      };
      ssd = {
        type = "disk";
        device = "${idpart}/ata-Micron_2400_MTFDKBK512QFM_232240F15D36";
        content = {
          type = "gpt";
          partitions = ssdpartitions;
        };
      };
      sysroot = zfs.entireDisk {
        device = "ata-TOSHIBA_MQ01ABD050V_34HES5WXS";
      };
      szdev = zfs.entireDisk {
        device = "ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK";
      };
    };
    zpool = { inherit zroot sz; };
  };
}
