{
  lib,
  pkgs,
  username,
  ...
}:
{
  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (_: prev: {
      mbrola-voices = prev.mbrola-voices.override {
        languages = [ "*1" ];
      };
    })
  ];

  nix = {
    settings = {
      max-jobs = 1;
      cores = 2;
      trusted-users = [
        "root"
        "nixstrap"
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://attic.xuyh0120.win/lantian"
        "https://nix-community.cachix.org"
      ];
      extra-trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      http-connections = 100;
    };
  };
}
