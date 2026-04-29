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
  xfs = (import ./lib/xfs.nix);
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
      device = "/dev/zram1";
      fsType = "ext4";
      neededForBoot = true;
      options = [ "noatime" "x-systemd.device-timeout=0" ];
    };

    "/nix" = bcachefs {
      extraOptions = [
        "X-mount.subdir=subvolumes/nix"
        "x-systemd.device-timeout=300"
        "x-systemd.mount-timeout=300"
      ];
    };

    "/nix/persist/etc" = bcachefs {
      extraOptions = [
        "X-mount.subdir=subvolumes/etc"
        "x-systemd.device-timeout=300"
        "x-systemd.mount-timeout=300"
      ];
    };

    "/nix/persist" = xfs {
      depends = [ "/nix" ];
      extraOptions = [ "logdev=/dev/mapper/persistlogcrypt" ];
    };

    "/nix/persist/storage" = xfs {
      device = "/dev/vg1/storage";
      depends = [ "/nix/persist" ];
      extraOptions = [ "logdev=/dev/mapper/storagelogcrypt" ];
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

  boot = {
    extraModulePackages = [
      (pkgs.callPackage ./custom/apple-bce.nix { kernel = kernelBuild.kernel; })
    ];
     resumeDevice = "/dev/mapper/swapcrypt";
    kernelParams = [ "video=DP-3:1600x900@60" "systemd.gpt_auto=0" "rootwait" "zram.num_devices=2" ] ++ params { };
    kernelPackages = lib.mkForce (helpers.kernelModuleLLVMOverride (kernelBuild.packages));
    initrd = {
      kernelModules = [
        "apple-bce"
        "aes_ni"
        "brcmfmac_wcc"
        "brcmfmac"
        "btrfs"
        "cryptd"
        "dm_crypt"
        "dm_mod"
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
        "zram"
        # "vfio_virqfd"
        # "vfio_pci"
        # "vfio_iommu_type1"
        # "vfi"
      ];
      services.lvm.enable = true;
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
            keydevice = "${idpart}/usb-Generic_Mass-Storage_20240418000000-0:0-part1";
          in {
            wantedBy = [ "initrd.target" ];
            requiredBy = [ "sysroot.mount" ];
            before = [
              "dev-mapper-persist.device"
              "dev-mapper-storage.device"
              "initrd-fs.target"
              "sysroot.mount"
            ];
            after = [ "systemd-modules-load.service" ];
            unitConfig.DefaultDependencies = false;
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            path = [
              pkgs.util-linux
              pkgs.bcachefs-tools
              pkgs.cryptsetup
              pkgs.systemd
              pkgs.e2fsprogs
              pkgs.coreutils
              pkgs.lvm2
            ];
            script = ''
              set -e
              mkdir -p /media

              echo 4G > /sys/block/zram1/disksize
              mkfs.ext4 -m 0 -O "^has_journal,^huge_file,^flex_bg" /dev/zram1

              for i in {1..10}; do
                if [ -e "${keydevice}" ]; then
                    echo "Appear in attempt $i"
                    if mount -t btrfs -o ro,noatime,ssd,discard=async "${keydevice}" /media; then
                        echo "Found key device"
                        break
                    fi
                fi
                echo "Waiting key device... ($i/10)"
                udevadm settle --timeout=2 || true && udevadm trigger --action=add --subsystem-match=block
                sleep 1
               done

               cryptsetup open ${idpart}/ata-WDC_WD5000LPSX-75A6WT0_WX12A21JEEPK persist --key-file /media/secret.key
               cryptsetup open ${idpart}/ata-ST500LT012-1DG142_S3PMCMHT storage --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-swapcrypt swapcrypt --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-persistcachecrypt persistcachecrypt --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-persistlogcrypt persistlogcrypt --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-storagecachecrypt storagecachecrypt --key-file /media/secret.key
               cryptsetup open ${partlabel}/disk-ssd-storagelogcrypt storagelogcrypt --key-file /media/secret.key

               for i in {1..30}; do
                 if [ -e /dev/bcache0 ] && [ -e /dev/bcache1 ] && [ -e /dev/mapper/persist ]  && [ -e /dev/mapper/storage ]; then
                    echo "Appear in attempt $i"
                    udevadm trigger --action=add --subsystem-match=block
                    udevadm settle
                    lvm vgscan --mknodes
                    lvm vgchange -ay vg0
                    lvm vgchange -ay vg1
                    break
                 fi
                 echo "Waiting persist and storage devices... ($i/30)"
                 udevadm settle --timeout=3 || true && udevadm trigger --action=add --subsystem-match=block
                 sleep 1
                done
            '';
          };
        };
      };
    };
  };
}
