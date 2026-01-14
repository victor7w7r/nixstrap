{
  pkgs,
  modulesPath,
  self,
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
    bluetui
    bluetuith
    radeontop
    amdgpu_top
  ];

  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  services.asusd = {
    enable = true;
    enableUserService = true;
  };

}
