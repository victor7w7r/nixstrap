let
  winmod = import ../lib/windows.nix;

  nvmepartitions = {
    esp = (import ../lib/esp.nix) { };
    msr = winmod.msr { };
    recovery = winmod.recovery { priority = 3; };
    meta = (import ../lib/lvm.nix) {
      vg = "vg1";
      size = "2G";
      priority = 4;
    };
    macos = {
      name = "macos";
      size = "110G";
      priority = 5;
    };
    systempv = (import ../lib/luks-lvm.nix) {
      size = "6G";
      priority = 6;
    };
    win = winmod.win { priority = 7; };
    shared = (import ../filesystems/shared.nix) { };
  };

  extssdpartitions = {
    cache = (import ../lib/lvm.nix) {
      vg = "vg1";
      size = "100G";
      priority = 1;
    };
    extssdpv = (import ../lib/luks-lvm.nix) {
      size = "100%";
      priority = 2;
    };
  };

  hardpartitions = {
    emergency = (import ../lib/emergency.nix) { priority = 1; };
    hardpv = (import ../lib/luks-lvm.nix) { vg = "vg1"; };
  };

  lvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    rootfs = (import ../filesystems/rootfs.nix) {
      hasVar = false;
      extraDirs = "/mnt/kvm /run/media/extssd /run/media/docs";
    };
    system = (import ../filesystems/system-btrfs.nix) { };
  };

  hardlvs = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    var = (import ../filesystems/var-only.nix) { };
    store = (import ../filesystems/store-only.nix) { size = "100G"; };
    home = (import ../filesystems/home-only.nix) { size = "100%"; };
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
      size = "100%";
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
