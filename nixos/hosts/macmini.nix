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
    "/" = zfs { preDataset = "local"; };
    "/nix" = zfs {
      pool = "zsys";
      dataset = "nix";
      depends = [ "/" ];
    };
    "/nix/persist" = zfs {
      pool = "zsys";
      dataset = "persist";
      depends = [ "/nix" ];
    };
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
