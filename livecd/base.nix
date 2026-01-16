{
  config,
  lib,
  options,
  pkgs,
  modulesPath,
  ...
}:
with lib;
{
  imports = [
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/clone-config.nix"
    "${modulesPath}/installer/scan/detected.nix"
    "${modulesPath}/installer/scan/not-detected.nix"
    "${modulesPath}/installer/cd-dvd/iso-image.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"

    (import ./core)
    (import ./home)
  ];

  system.stateVersion = "24.05";
  system.nixos.variant_id = lib.mkDefault "installer";

  console.packages = options.console.packages.default ++ [ pkgs.terminus_font ];

  isoImage = {
    isoName = "nixstrap-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  swapDevices = mkImageMediaOverride [ ];
  fileSystems = mkImageMediaOverride config.lib.isoFileSystems;

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

}
