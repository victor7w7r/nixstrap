{ flake-config, ... }:
{
  flake-file.nixConfig = flake-config // {
    lazy-trees = true;
    submodules = true;
  };

  _module.args = {
    flake-config = {
      always-allow-substitutes = true;
      allow-import-from-derivation = true;
      accept-flake-config = true;
      auto-optimise-store = true;
      use-xdg-base-directories = true;

      experimental-features = [
        "nix-command"
        #"ca-derivations"
        "flakes"
        "fetch-closure"
        "parse-toml-timestamps"
        "blake3-hashes"
        "verified-fetches"
        "pipe-operators"
        "git-hashing"
      ];

      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
        "https://vanilla-mobile-nixos.cachix.org"
        "https://cache.xinux.uz"
        #"https://cache.saumon.network/proxmox-nixos"
        #"https://nix-gaming.cachix.org"
        #"https://attic.xuyh0120.win/lantian"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "vanilla-mobile-nixos.cachix.org-1:nicMQxxTD4n6PM9dCvylqsCOCA6M2C6gybbCKrei8AQ="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
        #"proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
        #"lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        #"nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];

      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://install.determinate.systems"
        #"https://attic.xuyh0120.win/lantian"
      ];

      extra-substituters = [ ];
      extra-trusted-public-keys = [ ];
    };
    nix-config = {
      connect-timeout = 5;
      builders-use-substitutes = true;
      download-buffer-size = 524288000;
      fallback = true;
      http-connections = 128;
      keep-build-log = false;
      keep-derivations = false;
      keep-going = true;
      max-silent-time = 3600;
      max-substitution-jobs = 128;
      narinfo-cache-negative-ttl = 0;
      warn-dirty = false;
      max-jobs = "auto";
      cores = 0;

      trusted-users = [
        "root"
        "@admin"
        "@wheel"
      ];
    };
  };
}
