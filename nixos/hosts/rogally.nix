{
  pkgs,
  modulesPath,
  self,
  username,
  ...
}:
let
  options = import ./common/options.nix;
  params = import ./common/params.nix;
  systems = import ./common/filesystems.nix;
  security = import ./common/security.nix;

  sec = security { inherit self; };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  powerManagement.cpuFreqGovernor = "ondemand";

  fileSystems = {
    "/games" = {
      device = "/dev/disk/by-partlabel/disk-main-games";
      fsType = "btrfs";
      options = options.btrfsOptions;
    };
  }
  // systems { homeDisk = ""; };

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
