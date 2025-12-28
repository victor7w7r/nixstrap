{ pkgs, ... }:
{
  programs.plasma.enable = true;
  programs.plasma.overrideConfig = true;

  services.gpg-agent = {
    pinentry.package = pkgs.kwalletcli;
    extraConfig = "pinentry-program ${pkgs.kwalletcli}/bin/pinentry-kwallet";
  };

  imports = [
    (import ./config/essentials.nix)
    (import ./config/kwin.nix)
    (import ./config/dolphin.nix)
    (import ./config/panels.nix)
    (import ./config/input.nix)
    (import ./config/fonts.nix)
  ];

  home.packages = [
    pkgs.application-title-bar
    (pkgs.callPackage ./custom/kmenu.nix { })
    (pkgs.callPackage ./custom/kurve.nix { })
    (pkgs.callPackage ./custom/layan.nix { })
    (pkgs.callPackage ./custom/kde-control-station.nix { })
    (pkgs.callPackage ./custom/panel-spacer-extended.nix { })
    (pkgs.callPackage ./custom/plasma-drawer.nix { })
    (pkgs.callPackage ./custom/wallpaper-effects.nix { })
  ];
}
