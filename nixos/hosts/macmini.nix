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
  bcachefs = (import ./lib/bcachefs.nix);
  shared = (import ./lib/shared.nix) { };
  audio = (pkgs.callPackage ./custom/apple-t2-better-audio.nix { });
in
{
  nixpkgs.overlays = [
    (_final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];


  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (shared);

    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };
    "/nix" = bcachefs {
      extraOptions = [ "X-mount.subdir=subvolumes/nix" ];
    };

    "/nix/persist/etc" = bcachefs {
      extraOptions = [ "X-mount.subdir=subvolumes/etc" ];
    };

    "/nix/persist" = xfs {
      depends = [ "/nix" ];
    };

    "/nix/persist/storage" = xfs {
      device = "/dev/vg0/storage";
      depends = [ "/nix/persist" ];
    };
  };

  swapDevices = [
    {
      device = "/dev/mapper/swapcrypt";
      discardPolicy = "both";
      options = [ "nofail" ];
    }
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  boot = {
    extraModulePackages = [
      (pkgs.callPackage ./custom/apple-bce.nix { kernel = kernelBuild.kernel; })
    ];
    kernelParams = [ "video=DP-3:1600x900@60" ] ++ params { };
    kernelPackages = lib.mkForce (helpers.kernelModuleLLVMOverride (kernelBuild.packages));
    initrd = {
      kernelModules = [
        "apple-bce"
        "brcmfmac_wcc"
        "brcmfmac"
        "btrfs"
        "bcache"
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
      systemd = {
        storePaths = [
          "${pkgs.btrfs-progs}/bin/btrfs"
          "${pkgs.util-linux}/bin/mount"
          "${pkgs.util-linux}/bin/umount"
          "${pkgs.coreutils}/bin/sleep"
          "${pkgs.systemd}/bin/udevadm"
        ];
        services = {
          setup-storage-stack = let
            partlabel = "/dev/disk/by-partlabel";
            idpart = "/dev/disk/by-id";
          in {
            wantedBy = [ "initrd.target" ];
            before = [
              "initrd-fs.target"
              "sysroot.mount"
            ];
            after = [
              "systemd-modules-load.service"
            ];
            unitConfig.DefaultDependencies = false;
            path = [
              pkgs.util-linux
              pkgs.bcachefs-tools
              pkgs.systemd
              pkgs.coreutils
            ];
            script = ''
              set -e
              mkdir -p /media
              DEVICE="/dev/disk/by-id/usb-Generic_Mass-Storage_20240418000000-0:0-part1"

              udevadm trigger --action=add --subsystem-match=block
              for i in {1..30}; do
                if [ ! -e "$DEVICE" ]; then
                    udevadm settle --timeout=3 || true
                fi
                if [ -e "$DEVICE" ]; then
                    echo "Appear in attempt $i"
                    if mount -t btrfs -o rw,noatime,ssd,discard=async "$DEVICE" /media; then
                        break
                    fi
                fi
                echo "Waiting SCSI/USB... ($i/30)"
                sleep 1
                done

                cryptsetup open ${idpart}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK persist --key-file /tmp/key.txt
                cryptsetup open ${idpart}/ata-ST500LT012-1DG142_S3PMCMHT storage --key-file /tmp/key.txt

                cryptsetup open ${partlabel}/disk-ssd-persistcachecrypt persistcachecrypt --key-file /tmp/key.txt
                cryptsetup open ${partlabel}/disk-ssd-persistlogcrypt persistlogcrypt --key-file /tmp/key.txt
                echo /dev/mapper/persist | tee /sys/fs/bcache/register || true

                cryptsetup open ${partlabel}/disk-ssd-storagecachecrypt storagecachecrypt --key-file /tmp/key.txt || true
                cryptsetup open ${partlabel}/disk-ssd-storagelogcrypt storagelogcrypt --key-file /tmp/key.txt || true
                echo /dev/mapper/storage | tee /sys/fs/bcache/register || true

                vgscan -ay
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
    ydotool
    kdePackages.plasma-thunderbolt
  ];

  programs.ydotool.enable = true;
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="input"
  '';
  services.udev.packages = [ audio.audioUdev ];

  systemd.tmpfiles.rules = [
    "w /sys/block/bcache0/bcache/cache_mode - - - - writethrough"
    "w /sys/block/bcache1/bcache/cache_mode - - - - writethrough"
  ];

}
