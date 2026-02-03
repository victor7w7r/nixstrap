let
  winmod = import ../lib/windows.nix;

  nvmepartitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    recovery = winmod.recovery { priority = 3; };
    macos = {
      name = "macos";
      size = "110G";
      priority = 4;
    };
    systempv = (import ../lib/luks.nix) {
      size = "6G";
      content = {
        vg = "vg0";
        type = "lvm_pv";
      };
      priority = 5;
    };
    win = winmod.win { priority = 6; };
    shared = (import ../filesystems/shared.nix) { };
  };

  extssdpartitions = {
    extssdpv = (import ../lib/luks.nix) {
      content = {
        vg = "vg0";
        type = "lvm_pv";
      };
    };
  };

  hardpartitions = {
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
    hardpv = (import ../lib/luks.nix) {
      allowDiscards = false;
      content = {
        vg = "vg1";
        type = "lvm_pv";
      };
      priority = 3;
    };
  };

  lvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    syscrypt = (import ../lib/btrfs.nix) {
      name = "system";
      label = "system";
      lvmPool = "thinpool";
      size = "5G";
      inherit subvolumes;
    };
  };

  hardlvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    home = (import ../filesystems/home-only.nix) { size = "400G"; };
  };

  extssdlvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    lightdocs = (import ../filesystems/xfs.nix) {
      name = "lightdocs";
      label = "lightdocs";
      size = "100G";
    };
    docs = (import ../filesystems/btrfs.nix) {
      name = "docs";
      size = "200G";
      subvolumes = {
        "/docs".mountpoint = "/run/media/docs";
        "/docsnaps".mountpoint = "/run/media/.docsnaps";
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
          inherit nvmepartitions;
        };
      };
      storage = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = hardpartitions;
        };
      };
    };
    lvm_vg = {
      vg0 = {
        type = "lvm_vg";
        inherit lvs;
      };
      vg1 = {
        type = "lvm_vg";
        lvs = hardlvs;
      };
    };
  };
}
