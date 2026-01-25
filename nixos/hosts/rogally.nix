{
  pkgs,
  self,
  username,
  ...
}:
let
  sharedDir = "/games";
  security = import ./lib/security.nix;
  sec = security { inherit self; };
  params = import ./lib/kernel-params.nix;

  rootfs = (import ./filesystems/rootfs.nix) { };
  boot = (import ./filesystems/boot.nix) { };
  tmp = import ./filesystems/tmp.nix;
  system = (import ./filesystems/system-xfs.nix) {
    hasHome = true;
    hasStore = true;
  };
  shared = import (import ./filesystems/shared.nix) {
    inherit sharedDir;
    partlabel = "games";
  };
in
{
  fileSystems = {
    inherit (rootfs) "/" "/var";
    inherit (boot) "/boot" "/boot/emergency";
    inherit (tmp) "/tmp" "/var/tmp" "/var/cache";
    inherit (system)
      "/.nix"
      "/nix"
      "/etc"
      "/root"
      "/home"
      ;
    inherit (shared) sharedDir;
  };

  boot = {
    kernelParams = [
      "amd_pstate=active"
      "amd_iommu=on"
    ]
    ++ params { };
    initrd = {
      secrets = sec.secrets;
      luks.devices = {
        system = sec.system;
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
      tod = {
        enable = true;
        driver = pkgs.nur.repos.Vortriz.libfprint-focaltech-2808-a658-alt;
      };
    };
  };
}
