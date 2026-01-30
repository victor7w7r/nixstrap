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

  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = [ ];
    nh = {
      enable = false;
      #clean.enable = true;
      #clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/user/my-nixos-config";
    };

    nix-index = {
      enable = true;
      enableZshIntegration = false;
      #nix-index-database.comma.enable = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 5;
    distributedBuilds = true;
    optimise.automatic = true;
    package = lib.mkDefault (pkgs.lix);
    settings = {
      max-jobs = 1;
      cores = 2;
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [
        "root"
        username
      ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-substituters = [
        "https://nix-gaming.cachix.org"
        "https://nix-community.cachix.org"
        "https://attic.xuyh0120.win/lantian"
      ];
      extra-trusted-public-keys = [
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      http-connections = 100;
    };
  };

  #sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  #sops.defaultSopsFile = ./secrets/example.yaml;
  #sops.secrets."example" = { };
}
