{ user, lib, ... }:
{
  system = {
    checks.verifyBuildUsers = false;
    stateVersion = 6;
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  determinateNix.customSettings = {
     flake-registry = "/etc/nix/flake-registry.json";
     sandbox = "relaxed";
     trusted-users = [ "root" "@admin" user ];
     warn-dirty = false;

     max-jobs = 1;
     cores = 2;
     max-silent-time = 3600;

     keep-outputs = true;
     keep-derivations = true;
     fallback = true;
     keep-going = true;

     download-buffer-size = 524288000;
     http-connections = 128;
     max-substitution-jobs = 64;
     connect-timeout = 5;

     builders-use-substitutes = true;
     narinfo-cache-positive-ttl = 30;
     narinfo-cache-negative-ttl = 1;

     extra-substituters = [
       "https://nix-community.cachix.org/"
       "https://cache.nixos.org/"
     ];

     extra-trusted-public-keys = [
       "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
       "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
     ];
     trusted-substituters = [ "https://install.determinate.systems" ];

     experimental-features = [
       "nix-command"
       "flakes"
       "ca-derivations"
       "fetch-closure"
       "parse-toml-timestamps"
       "blake3-hashes"
       "verified-fetches"
       "pipe-operators"
       "no-url-literals"
       "git-hashing"
     ];

     log-lines = 25;
   };


  nix = {
    enable = lib.mkForce false;
    nixPath = lib.mkDefault [ ];
    optimise.automatic = lib.mkDefault false;
  };

  documentation = {
    enable = false;
    doc.enable = false;
    info.enable = false;
    man.enable = false;
  };

  nix-homebrew = {
    enable = true;
    inherit user;
    enableFishIntegration = false;
    enableRosetta = false;
    autoMigrate = true;
    mutableTaps = false;
  };
}
