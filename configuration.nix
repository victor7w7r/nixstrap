{
  lib,
  pkgs,
  username,
  ...
}:
{
  system.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = [ ];
    nh = {
      enable = false;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
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
      http-connections = 100;
    };
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://install.determinate.systems"
    ];
    substituters = [
      "https://chaotic-nyx.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    trusted-public-keys = [
      "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };

  #sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  #sops.defaultSopsFile = ./secrets/example.yaml;
  #sops.secrets."example" = { };
}
