{
  config,
  flavor,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/clone-config.nix"
    "${modulesPath}/installer/scan/detected.nix"
    "${modulesPath}/installer/scan/not-detected.nix"
    "${modulesPath}/installer/cd-dvd/iso-image.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  system = {
    extraDependencies = lib.mkForce [ ];
    nixos.variant_id = lib.mkDefault flavor;
    stateVersion = "24.05";
  };

  image.fileName = "nixstrap-${config.system.nixos.label}.iso";

  isoImage = {
    configurationName = flavor;
    makeBiosBootable = false;
    makeEfiBootable = true;
    makeUsbBootable = true;
    squashfsCompression = "xz -Xbcj x86 -Xdict-size 100% -b 128K -limit 75 -percentage";
  };

  documentation = {
    enable = false;
    nixos.enable = false;
    man.enable = false;
    doc.enable = false;
  };

  swapDevices = lib.mkImageMediaOverride [ ];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;

  boot.postBootCommands = ''
    for o in $(</proc/cmdline); do
      case "$o" in
        live.nixos.passwd=*)
          set -- $(IFS==; echo $o)
          echo "nixos:$2" | ${pkgs.shadow}/bin/chpasswd
          ;;
      esac
    done
  '';

  nix.settings = {
    max-jobs = 1;
    cores = 2;
    trusted-users = [
      "root"
      "nixstrap"
    ];
  };

}
