{
  nix-cachyos-kernel,
  pkgs,
  username,
  ...
}:
let
  params = import ./lib/kernel-params.nix;
  boot = (import ./lib/boot.nix) { };
  btrfs = (import ./lib/btrfs.nix);
  shared = (import ./lib/shared.nix) {
    sharedDir = "/run/media/games";
    partlabel = "games";
  };
  kernel = (import ./kernels/handheld.nix { inherit pkgs nix-cachyos-kernel; });
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (shared) "/run/media/games";
    "/" = btrfs { };
    "/nix" = btrfs { subvol = "nix"; };
    "/nix/persist" = btrfs {
      subvol = "persist";
      depends = [ "/nix" ];
    };
  };

  swapDevices = [ { device = "/dev/vg0/swapcrypt"; } ];
  boot = {
    kernelParams = [
      "amd_iommu=on"
    ]
    ++ params { };
    kernelPackages = kernel.packages;
    #pkgs.linuxPackages_lqx;
    initrd = {
      luks.devices.syscrypt = {
        device = "/dev/disk/by-partlabel/disk-main-syscrypt";
        crypttabExtraOpts = [ "tpm2-device=auto" ];
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
    ryzenadj
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
      ui.enable = true;
    };
    fprintd = {
      enable = true;
      package = pkgs.fprintd.override {
        libfprint = (pkgs.callPackage ./custom/focaltech.nix { });
      };
    };
  };
}
