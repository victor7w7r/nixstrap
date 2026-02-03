{ pkgs, self, ... }:
let
  sec = security { inherit self; };
  params = import ./lib/kernel-params.nix;
  security = import ./lib/security.nix;

  rootfs = (import ./filesystems/rootfs.nix) { };
  boot = (import ./filesystems/boot.nix) { };
  systemxfs = (import ./filesystems/system-xfs.nix) {
    hasHome = true;
    hasStore = true;
  };
in
{
  fileSystems = {
    inherit (rootfs) "/" "/var";
    inherit (boot) "/boot/emergency";
    inherit (systemxfs)
      "/.nix"
      "/nix"
      "/etc"
      "/root"
      "/home"
      ;
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
