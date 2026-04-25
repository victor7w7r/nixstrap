{
  pkgs,
  config,
  username,
  host,
  ...
}:
let
  ccacheConfigFile = pkgs.writeText "ccache.conf" ''
    compression = false
    file_clone = true
    max_size = 25G
    sloppiness = random_seed
    umask = 007
    compiler_check = content
  '';
in
{
  system.stateVersion = "26.05";

  system.autoUpgrade = {
    enable = true;
    dates = "Sat";
    allowReboot = true;
    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (_: prev: {
      mbrola-voices = prev.mbrola-voices.override {
        languages = [ "*1" ];
      };
    })

    (self: super: {
      ccacheWrapper = super.ccacheWrapper.override {
        extraConfig = ''
          CCACHE_DIR="/nix/var/cache/ccache"
          export CCACHE_CONFIGPATH="''${CCACHE_CONFIGPATH:-${ccacheConfigFile}}"
          if [ ! -d "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' does not exist"
            echo "Please create it with:"
            echo "  sudo mkdir -m0770 '$CCACHE_DIR'"
            echo "  sudo chown root:nixbld '$CCACHE_DIR'"
            echo "====="
            exit 1
          fi
          if [ ! -w "$CCACHE_DIR" ]; then
            echo "====="
            echo "Directory '$CCACHE_DIR' is not accessible for user $(whoami)"
            echo "Please verify its access permissions"
            echo "====="
            exit 1
          fi
        '';
      };
    })
  ];

  programs.ccache = {
    enable = true;
    cacheDir = "/nix/var/cache/ccache";
  };

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
      #enableZshIntegration = false;
      #nix-index-database.comma.enable = true;
    };
  };

  nix =
    let
      is-term-hosts = host == "v7w7r-rc71l" || host == "v7w7r-youyeetoox1";
      is-mac = host == "v7w7r-macmini81";
    in
    {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      daemonCPUSchedPolicy = if is-term-hosts then "batch" else "idle";
      daemonIOSchedPriority = if is-term-hosts then 0 else 5;
      distributedBuilds = true;
      optimise.automatic = true;
      #package = lib.mkDefault (pkgs.lix);
      settings = {
        extra-sandbox-paths = [
          "/nix/var/cache/ccache"
          "/nix/var/cache/sccache"
        ];
        max-jobs = if is-term-hosts then "auto" else 3;
        cores = if is-term-hosts then 0 else (if is-mac then 6 else 4);
        auto-optimise-store = true;
        allowed-users = [ "@wheel" ];
        trusted-users = [ username ];
        keep-derivations = true;
        keep-outputs = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.garnix.io"
        ];
        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        ];
        extra-substituters = [
          "https://nix-gaming.cachix.org"
          "https://nix-community.cachix.org"
          "https://attic.xuyh0120.win/lantian"
          "https://cache.saumon.network/proxmox-nixos"
        ];
        extra-trusted-public-keys = [
          "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
          "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        ];
        http-connections = 100;
      };
    };

  systemd.tmpfiles.rules =

    [
      "L+ /nix/var/cache/ccache/ccache.conf - - - - ${ccacheConfigFile}"
    ];

  sops = {
    defaultSopsFile = ./secrets/sec.yaml;
    age.sshKeyPaths = [ "/nix/persist/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      tunnel = { };
      cloudflare-token = { };
      password-db = { };
      seckey-d = { };
      ssh-vm-pub = { };
      ssh-vm-key = { };
      age-vm-key = { };
    };
    templates."couchdb-admins.ini".content = ''
      [admins]
      admin = ${config.sops.placeholder.password-db}
    '';
  };
}
