{
  pkgs,
  username,
  ...
}:
let
  params = import ./lib/kernel-params.nix;
  boot = (import ./filesystems/boot.nix) { };
  builder =
    {
      subvol ? "",
      isNix ? false,
      depends ? [ ],
    }:
    {
      device = "/dev/vg0/system";
      fsType = "btrfs";
      options = [
        "lazytime"
        "noatime"
        "compress=zstd"
        "discard=async"
        "subvol=@${subvol}"
      ]
      ++ (if isNix then [ "noacl" ] else [ ]);
      inherit depends;
      neededForBoot = true;
    };
  shared = (import ./filesystems/shared.nix) {
    sharedDir = "/run/media/games";
    partlabel = "games";
  };
in
{
  imports = [ import ./kernels ];
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (shared) "/run/media/games";
    "/" = builder { };
    "/nix" = builder { subvol = "nix"; };
    "/nix/persist" = builder {
      subvol = "persist";
      depends = [ "/nix" ];
    };
  };

  boot = {
    kernelParams = [
      "amd_pstate=active"
      "amd_iommu=on"
    ]
    ++ params { };
    kernelPackages = pkgs.linuxPackages-v7w7r-handheld;
    initrd = {
      availableKernelModules = [
        "autofs"
        "tpm-tis"
      ];
      luks.devices.syscrypt = {
        device = "/dev/disk/by-partlabel/disk-main-systempv";
        preLVM = true;
      };
    };
  };

  environment.defaultPackages = [ ];
  environment.systemPackages = with pkgs; [
    alsa-plugins
    alsa-utils
    alsa-firmware
    amdgpu_top
    bluetui
    bluetuith
    kdePackages.plasma-thunderbolt
    radeontop
    tbtools
    thunderbolt
  ];

  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  security.pam.services.ly = {
    name = "ly";
    enable = true;
    startSession = true;
    allowNullPassword = false;
    fprintAuth = true;
  };

  services = {
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
    handheld-daemon = {
      enable = true;
      user = username;
    };
    fprintd = {
      enable = true;
      package = pkgs.fprintd.override {
        libfprint = (pkgs.callPackage ./custom/focaltech.nix { });
      };
    };
  };
}
