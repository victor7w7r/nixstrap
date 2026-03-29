let
  winmod = import ../lib/windows.nix;
  zfs = import ../lib/zfs.nix;

  applepartitions = {
    esp = (import ../lib/esp.nix) { };
    macos = {
      name = "macos";
      size = "110G";
      priority = 2;
    };
    sysetc = zfs.partition {
      size = "2G";
      pool = "zetc";
      priority = 3;
    };
    shared = zfs.partition {
      size = "100%";
      pool = "zshared";
    };
  };

  ssdpartitions = {
    emergency = (import ../lib/emergency.nix) { priority = 1; };
    msr = winmod.msr { };
    recovery = winmod.recovery { priority = 3; };
    win = winmod.win { priority = 4; };
    swap = zfs.partition {
      size = "2G";
      pool = "zswap";
      priority = 5;
    };
    syslog = zfs.partition {
      size = "2G";
      pool = "zsys";
      priority = 6;
    };
    datalog = zfs.partition {
      size = "2G";
      pool = "zdata";
      priority = 7;
    };
    sysspecial = zfs.partition {
      size = "40G";
      pool = "zsys";
      priority = 8;
    };
    dataspecial = zfs.partition {
      size = "40G";
      pool = "zdata";
      priority = 9;
    };
    syscache = zfs.partition {
      size = "70G";
      pool = "zsys";
      priority = 10;
    };
    datacache = zfs.partition {
      size = "70G";
      pool = "zdata";
      priority = 11;
    };
    root = zfs.partition {
      size = "30G";
      pool = "zroot";
      priority = 12;
    };
    ssdshared = zfs.partition {
      size = "100%";
      pool = "zssdshared";
    };
  };

  partlabel = "/dev/disk/by-partlabel";
  idpart = "/dev/disk/by-id";

  zroot = zfs.pool {
    isRoot = true;
    mode = "";
    datasets =
      zfs.preDataset { name = "local"; }
      // zfs.dataset {
        preDataset = "local";
        options = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
      };
  };
  zsys = zfs.pool {
    vdev = [ { members = [ "${idpart}/ata-ST500LT012-1DG142_S3PMCMHT" ]; } ];
    log = [ { members = [ "${partlabel}/disk-ssd-syslog" ]; } ];
    special = [ { members = [ "${partlabel}/disk-ssd-sysspecial" ]; } ];
    cache = [ "${partlabel}/disk-ssd-syscache" ];
    datasets =
      zfs.preDataset { }
      // zfs.dataset {
        name = "nix";
        pool = "zsys";
        mountpoint = "/nix";
        options = {
          canmount = "on";
          compression = "zstd";
          "com.sun:auto-snapshot" = "true";
        };
      }
      // zfs.dataset {
        name = "persist";
        pool = "zsys";
        mountpoint = "/nix/persist";
        options = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///media/secret.key";
          "com.sun:auto-snapshot" = "true";
        };
      };
  };
  zdata = zfs.pool {
    vdev = [ { members = [ "${idpart}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK" ]; } ];
    log = [ { members = [ "${partlabel}/disk-ssd-datalog" ]; } ];
    special = [ { members = [ "${partlabel}/disk-ssd-dataspecial" ]; } ];
    cache = [ "${partlabel}/disk-ssd-datacache" ];
    datasets =
      zfs.preDataset { }
      // zfs.dataset {
        pool = "zdata";
        name = "storage";
        mountpoint = "/nix/persist/storage";
        options = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///media/secret.key";
          "com.sun:auto-snapshot" = "true";
        };
      };
  };
  zetc = zfs.pool {
    mode = "";
    datasets =
      zfs.preDataset { }
      // zfs.dataset {
        pool = "zetc";
        name = "etc";
        mountpoint = "/nix/persist/etc";
      };
  };

  zshared = zfs.pool {
    mode = "";
    datasets =
      zfs.preDataset { }
      // zfs.dataset {
        pool = "zshared";
        name = "shared";
        mountpoint = "/nix/persist/shared";
        options = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///media/secret.key";
          "com.sun:auto-snapshot" = "true";
        };
      };
  };
  zssdshared = zfs.pool {
    mode = "";
    datasets =
      zfs.preDataset { }
      // zfs.dataset {
        pool = "zssdshared";
        name = "ssdshared";
        mountpoint = "/nix/persist/ssdshared";
        options = {
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///media/secret.key";
          "com.sun:auto-snapshot" = "true";
        };
      };
  };
  zswap = zfs.pool {
    mode = "";
    datasets =
      zfs.preDataset { name = "local"; }
      // zfs.volume {
        name = "swap";
        size = "1800M";
        preDataset = "local";
        options = {
          compression = "zle";
          logbias = "throughput";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///media/secret.key";
          primarycache = "metadata";
          secondarycache = "none";
        };
        content = {
          type = "swap";
          discardPolicy = "both";
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
          partitions = applepartitions;
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
      sysnix = zfs.entireDisk {
        device = "ata-ST500LT012-1DG142_S3PMCMHT";
        pool = "zsys";
      };
      data = zfs.entireDisk {
        device = "ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK";
        pool = "zdata";
      };
    };
    zpool = {
      inherit
        zsys
        zdata
        zetc
        zshared
        zssdshared
        #zswap
        zroot
        ;
    };
  };
}
