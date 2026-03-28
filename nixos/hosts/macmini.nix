{
  inputs,
  host,
  config,
  kernelData,
  lib,
  pkgs,
  ...
}:
let
  intelParams = import ./lib/intel-params.nix;
  helpers = pkgs.callPackage "${inputs.nix-cachyos-kernel.outPath}/helpers.nix" { };
  kernelBuild = (pkgs.callPackage ../kernel) {
    inherit
      helpers
      host
      kernelData
      inputs
      ;
  };
  params = import ./lib/kernel-params.nix;
  boot = (import ./lib/boot.nix) {
    emergencyDisk = "ssd";
  };
  btrfs = (import ./lib/btrfs.nix);
  zfs = import ./lib/zfs.nix;
in
{

  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    "/" = zfs { preDataset = "local"; };
    "/nix" = zfs { pool = "zsys"; dataset = "nix"; depends = [ "/" ]; };
    "/nix/persist" = zfs { pool = "zsys"; dataset = "persist";  depends = [ "/nix" ]; };
    "/nix/persist/etc" = zfs {
      pool = "zetc";
      dataset = "etc";
      depends = [ "/nix/persist" ];
    };
    "/nix/persist/storage" = zfs {
      pool = "zdata";
      neededForBoot = false;
      depends = [ "/nix/persist" ];
      dataset = "storage";
    };
    "/nix/persist/shared" = zfs {
      pool = "zshared";
      neededForBoot = false;
      depends = [ "/nix/persist" ];
      dataset = "shared";
    };
    "/nix/persist/ssdshared" = zfs {
      pool = "zssdshared";
      neededForBoot = false;
      depends = [ "/nix/persist" ];
      dataset = "ssdshared";
    };
  };
  swapDevices = [
    {
      device = "/dev/zd0";
      discardPolicy = "both";
      options = [ "nofail" ];
    }
  ];
  boot = {
    kernelParams = [ "intel_iommu=on" ] ++ intelParams ++ params { };
    kernelPackages = lib.mkForce (
      (helpers.kernelModuleLLVMOverride (kernelBuild.packages)).extend (
        _self: _super: {
          kernel_configfile = _super.kernel.configfile;
          zfs_cachyos = pkgs.cachyosKernels.zfs-cachyos-lto.override { kernel = kernelBuild.kernel; };
        }
      )
    );

    zfs = {
      package = config.boot.kernelPackages.zfs_cachyos;
      requestEncryptionCredentials = true;
      forceImportAll = false;
      forceImportRoot = true;
    };
    initrd = {
      kernelModules = [
        "zfs"
        "btrfs"
        "uas"
        "usb_storage"
        "ahci"
        "usbhid"
        "sd_mod"
        "uhci_hcd"
        "ehci_hcd"
        "xhci_pci"
        "usbcore"
        # "vfio_virqfd"
        # "vfio_pci"
        # "vfio_iommu_type1"
        # "vfi"
      ];
      supportedFilesystems = [ "zfs" ];
      systemd = {
        storePaths = [
          "${pkgs.btrfs-progs}/bin/btrfs"
          "${pkgs.util-linux}/bin/mount"
          "${pkgs.util-linux}/bin/umount"
          "${pkgs.coreutils}/bin/sleep"
          "${pkgs.systemd}/bin/udevadm"
        ];
      services = {
        zfs-import-zroot.enable = false;
        zfs-import-zsys.enable = false;
        zfs-import-zetc.enable = false;
        zfs-import-zdata.enable = false;
        zfs-import-zshared.enable = false;
        zfs-import-zssdshared.enable = false;
        zfs-import-zswap.enable = false;

        zfs-setimport = {
          wantedBy = [ "initrd.target" ];
          before = [
            "rollback-zfs.service"
            "initrd-fs.target"
            "sysroot.mount"
          ];
          after = [
            "systemd-modules-load.service"
            "systemd-udev-settle.service"
            "dev-disk-by-id.device"
          ];
          wants = [ "systemd-udev-settle.service" ];
          unitConfig.DefaultDependencies = false;
          path = [
            config.boot.zfs.package
            pkgs.util-linux
            pkgs.systemd
            pkgs.coreutils
          ];
          script = ''
            set -e
            mkdir -p /media

            DISK1="/dev/disk/by-id/ata-ST500LT012-1DG142_S3PMCMHT"
            DISK2="/dev/disk/by-id/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK"
            DISK3="/dev/disk/by-id/ata-Micron_2400_MTFDKBK512QFM_232240F15D36"
            KEYDISK="/dev/disk/by-id/usb-Generic_Mass-Storage_20240418000000-0:0"
            udevadm trigger --action=add --subsystem-match=block

            for i in {1..30}; do
                if [ ! -e "$DISK1" ] || [ ! -e "$DISK2" ] || [ ! -e "$DISK3" ] || [ ! -e "$KEYDISK" ]; then
                    udevadm settle --timeout=4 || true
                else
                    echo "Ready for boot in attempt $i"
                    if mount -t btrfs -o rw,noatime,ssd,discard=async "$KEYDISK" /media; then
                        break
                    fi
                fi
                echo "Waiting SCSI/USB... ($i/30)"
                sleep 1
            done

            zpool import -f -N -a -d /dev/disk/by-id
            zfs rollback -r zroot/local/root@empty
            cat /media/secret.key | zfs load-key zsys/safe/persist
            cat /media/secret.key | zfs load-key zdata/safe/storage
            cat /media/secret.key | zfs load-key zswap/local/swap
            #cat /media/secret.key | zfs load-key zshared/safe/shared
            #cat /media/secret.key | zfs load-key zssdshared/safe/ssdshared
          '';

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
          };
        };
      };
      };
    };

  };

  environment.systemPackages = with pkgs; [
    bolt
    tbtools
    thunderbolt
    kdePackages.plasma-thunderbolt
  ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "Sat, 02:00";
      pools = [
        "zsys"
        "zdata"
        "zetc"
        "zssdshared"
        "zshared"
      ];
    };

    autoSnapshot = {
      enable = true;
      frequent = 4;
      hourly = 24;
      daily = 7;
      weekly = 4;
      monthly = 12;
      flags = "-k -p";
    };
    trim.enable = true;
    trim.interval = "weekly";
  };

}
