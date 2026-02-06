let
  winmod = import ../lib/windows.nix;

  nvmepartitions = {
    esp = (import ../lib/esp.nix) { };
    /*
      vmmeta = (import ../lib/lvm.nix) {
      vg = "vgsrv0";
      size = "1G";
      priority = 2;
    */
    vmcache = (import ../lib/lvm.nix) {
      vg = "vgsrv0";
      size = "32G";
      priority = 3;
    };
    cloudcache = (import ../lib/lvm.nix) {
      vg = "vgsrv1";
      size = "120G";
      priority = 4;
    };
    systempv = (import ../lib/lvm.nix) {
      vg = "vgsrv0";
      priority = 5;
    };
  };

  satapartitions = {
    msr = winmod.msr { priority = 1; };
    emergency = (import ../lib/emergency.nix) { priority = 2; };
    recovery = winmod.recovery { priority = 3; };
    cloudmeta = (import ../lib/luks-lvm.nix) {
      vg = "vgsrv1";
      size = "4G";
      priority = 4;
    };
    win = winmod.win {
      size = "100%";
      priority = 5;
    };
  };

  vmpartitions = {
    vmpv = (import ../lib/luks-lvm.nix) {
      allowDiscards = false;
      keyFile = "/tmp/vmkey.key";
      name = "vmpv";
      priority = 1;
      label = "vmpv";
      randomKeyName = "vmentropykey.key";
      vg = "vgsrv0";
    };
  };

  cloudpartitions = {
    cloudpv = (import ../lib/luks-lvm.nix) {
      allowDiscards = false;
      keyFile = "/tmp/cloudkey.key";
      name = "cloudpv";
      priority = 1;
      label = "cloudpv";
      randomKeyName = "cloudentropykey.key";
      vg = "vgsrv1";
    };
  };

  lvsystem = {
    thinpool = {
      size = "100%";
      lvm_type = "thin-pool";
    };
    rootfs = (import ../filesystems/rootfs.nix) { };
    home = (import ../filesystems/home-only.nix) { };
    store = (import ../filesystems/store-only.nix) { };
    system = (import ../filesystems/system-btrfs.nix) { };
    var = (import ../filesystems/var-only.nix) { };
  };

  /*
    TODO:
      - Setup partitions for every disk with coherence
      - Put nix store in hdd
      - Setup the cache and the meta in desired space
    postCreateHook = ''
        lvcreate --yes -l 5%FREE -n root-cache-meta lvm ${ssd}-part3
        lvcreate --yes -l 100%FREE -n root-cache-data lvm ${ssd}-part3
        lvconvert --yes --type cache-pool --cachemode writeback --poolmetadata lvm/root-cache-meta lvm/root-cache-data
        lvcreate --yes -l 100%FREE -n root lvm ${hdd}-part1
        lvconvert --yes --type cache --cachepolicy smq --cachepool lvm/root-cache-data lvm/root
        mkfs.btrfs /dev/lvm/root
        mount /dev/lvm/root /mnt -o compress=zstd:1,noatime
    '';

    lvconvert --type cache \
      --cachemode writeback \
      --cachepolicy smq \
      --chunksize 512K \
      vgdata/lv_hdd \
      vgdata/lv_cache
  */

in
{
  disko.devices = {
    disk = {
      stick = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = nvmepartitions;
        };
      };
      sata = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = satapartitions;
        };
      };
    };

    lvm_vg = {
      vgsrv0 = {
        type = "lvm_vg";
        lvs = lvsystem;
      };
    };
  };
}
