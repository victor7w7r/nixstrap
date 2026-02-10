let
  winmod = import ../lib/windows.nix;
  zfs = import ../lib/zfs.nix;

  internalpartitions = {
    esp = (import ../lib/esp.nix) { };
    macos = {
      name = "macos";
      size = "110G";
      priority = 4;
    };
    sysetc = zfs.partition {
      size = "2G";
      pool = "zetc";
      priority = 5;
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
      priority = 3;
    };
    syslog = zfs.partition {
      size = "2G";
      priority = 4;
    };
    datalog = zfs.partition {
      size = "2G";
      pool = "zdata";
      priority = 5;
    };
    sysspecial = zfs.partition {
      size = "40G";
      priority = 6;
    };
    dataspecial = zfs.partition {
      size = "40G";
      pool = "zdata";
      priority = 7;
    };
    syscache = zfs.partition {
      size = "70G";
      priority = 8;
    };
    datacache = zfs.partition {
      size = "70G";
      pool = "zdata";
      priority = 9;
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

  zdata = zfs.pool {
    vdev = [ { members = [ "${idpart}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK" ]; } ];
    log = [ { members = [ "${partlabel}/disk-ssd-szlog" ]; } ];
    special = [ { members = [ "${partlabel}/disk-ssd-szspecial" ]; } ];
    cache = [ "${partlabel}/disk-ssd-szcache" ];
    datasets = zfs.dataset {
      pool = "zdata";
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
  zetc = zfs.pool {
    mode = "";
    datasets = zfs.dataset {
      pool = "zetc";
      name = "etc";
      mountpoint = "/nix/persist/etc";
    };
  };
  zshared = zfs.pool {
    mode = "";
    datasets = zfs.dataset {
      pool = "zshared";
      name = "shared";
      mountpoint = "/nix/persist/shared";
    };
  };
  zssdshared = zfs.pool {
    mode = "";
    datasets = zfs.dataset {
      pool = "zssdshared";
      name = "ssdshared";
      mountpoint = "/nix/persist/sshshared";
    };
  };
  zswap = zfs.pool {
    mode = "";
    datasets = zfs.volume {
      name = "swap";
      options = {
        volblocksize = "4096";
        compression = "zle";
        logbias = "throughput";
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        sync = "always";
        primarycache = "metadata";
        secondarycache = "none";
        "com.sun:auto-snapshot" = "false";
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
        device = "ata-TOSHIBA_MQ01ABD050V_34HES5WXS"; # CHANGE
      };
      szdev = zfs.entireDisk {
        device = "ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK";
      };
    };
    zpool = {
      inherit
        zroot
        zdata
        zetc
        zshared
        zssdshared
        zswap
        ;
    };
  };
}
