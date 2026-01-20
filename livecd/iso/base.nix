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
    "${modulesPath}/profiles/clone-config.nix"
    "${modulesPath}/profiles/qemu-guest.nix"
    "${modulesPath}/installer/cd-dvd/iso-image.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  swapDevices = lib.mkImageMediaOverride [ ];
  fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;
  image.fileName = "nixstrap-${config.system.nixos.label}.iso";

  isoImage = {
    configurationName = flavor;
    makeBiosBootable = false;
    makeEfiBootable = true;
    makeUsbBootable = true;
    squashfsCompression = "xz -Xbcj x86 -Xdict-size 100% -b 512K -limit 75 -percentage";
  };

  documentation = with lib; {
    man.man-db.enable = mkDefault false;
    enable = mkDefault false;
    doc.enable = mkDefault false;
    info.enable = mkDefault false;
    man.enable = mkDefault false;
    nixos.enable = mkDefault false;
  };

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

  nixpkgs.overlays = [
    (_: prev: {
      mbrola-voices = prev.mbrola-voices.override {
        languages = [ "*1" ];
      };
    })
  ];

  nix.settings = {
    max-jobs = 1;
    cores = 2;
    trusted-users = [
      "root"
      "nixstrap"
    ];
  };

}
