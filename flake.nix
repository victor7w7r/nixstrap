# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  nixConfig = {
    accept-flake-config = true;
    allow-import-from-derivation = true;
    always-allow-substitutes = true;
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
      "fetch-closure"
      "parse-toml-timestamps"
      "blake3-hashes"
      "verified-fetches"
      "pipe-operators"
      "git-hashing"
    ];
    extra-substituters = [ ];
    extra-trusted-public-keys = [ ];
    lazy-trees = true;
    submodules = true;
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://cache.garnix.io"
      "https://cache.saumon.network/proxmox-nixos"
      "https://nix-gaming.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://install.determinate.systems"
    ];
    use-xdg-base-directories = true;
  };

  inputs = {
    adb_shell = {
      url = "github:JeffLIrion/adb_shell";
      flake = false;
    };
    adebar = {
      url = "https://codeberg.org/izzy/Adebar/archive/master.tar.gz";
      flake = false;
    };
    agenix.url = "github:ryantm/agenix";
    aim = {
      url = "github:mihaigalos/aim";
      flake = false;
    };
    apkinspector = {
      url = "github:erev0s/apkInspector";
      flake = false;
    };
    apkstudio = {
      url = "https://github.com/vaibhavpandeyvpz/apkstudio/releases/download/v6.3.0/ApkStudio-v6.3.0-x86_64.AppImage";
      flake = false;
    };
    app-manager = {
      url = "github:ASHWIN990/app-manager";
      flake = false;
    };
    appimage-thumbnailer = {
      url = "github:realmazharhussain/appimage-thumbnailer";
      flake = false;
    };
    apple-bce = {
      url = "github:deqrocks/apple-bce/5dd96d6ca0dd88d4a500639ed3923e258a81eb3f";
      flake = false;
    };
    armbian = {
      url = "github:MichaIng/build/299d8026da8ce06312c2d7d32220c2b01f4a2101";
      flake = false;
    };
    asus = {
      url = "gitlab:asus-linux/linux-g14/0e4aca508d46305a4d3fdf814c5d2bded30a2cdb";
      flake = false;
    };
    audio-share = {
      url = "https://github.com/mkckr0/audio-share/releases/download/v0.3.4/audio-share-server-cmd-linux.tar.gz";
      flake = false;
    };
    audiosource = {
      url = "https://github.com/gdzx/audiosource/releases/download/v1.5/audiosource";
      flake = false;
    };
    autoricer = {
      url = "github:3rfaan/autoricer";
      flake = false;
    };
    aya = {
      url = "https://github.com/liriliri/aya/releases/download/v1.14.2/AYA-1.14.2-linux-x86_64.AppImage";
      flake = false;
    };
    batfetch = {
      url = "github:ashish-kus/batfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bestfetch = {
      url = "gitlab:Maxb0tbeep/bestfetch";
      flake = false;
    };
    better-adb-sync = {
      url = "github:jb2170/better-adb-sync";
      flake = false;
    };
    bollywood = {
      url = "github:abloch/bollywood";
      flake = false;
    };
    breezy-desktop = {
      url = "github:wheaney/breezy-desktop";
      flake = false;
    };
    btrfs-data-recovery-map = {
      url = "https://github.com/davispuh/btrfs-data-recovery/releases/download/v1.0.0/btrfs-recovery-map";
      flake = false;
    };
    btrfs-data-recovery-scanner = {
      url = "https://github.com/davispuh/btrfs-data-recovery/releases/download/v1.0.0/btrfs-scanner";
      flake = false;
    };
    btrfs-du = {
      url = "github:nachoparker/btrfs-du";
      flake = false;
    };
    btrfsd = {
      url = "github:ximion/btrfsd";
      flake = false;
    };
    bunker-patches = {
      url = "github:amaanq/bunker-patches";
      flake = false;
    };
    cachyos-config = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };
    cachyos-linux = {
      url = "https://github.com/CachyOS/linux/releases/download/cachyos-6.18.38-1/cachyos-6.18.38-1.tar.gz";
      flake = false;
    };
    cachyos-patches = {
      url = "github:CachyOS/kernel-patches";
      flake = false;
    };
    carbonyl-amd64 = {
      url = "https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.linux-amd64.zip";
      flake = false;
    };
    carbonyl-arm64 = {
      url = "https://github.com/fathyb/carbonyl/releases/download/v0.0.3/carbonyl.linux-arm64.zip";
      flake = false;
    };
    cargofetch = {
      url = "github:arjav0703/cargofetch";
      flake = false;
    };
    catppuccin-refind = {
      url = "github:catppuccin/refind";
      flake = false;
    };
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    custom-packages.url = "github:Rishabh5321/custom-packages-flake";
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    den.url = "github:denful/den";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    disko.url = "github:nix-community/disko";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    gestures.url = "github:ferstar/gestures";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprdvd = {
      url = "github:nevimmu/hyprdvd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprfloat = {
      url = "github:nevimmu/hyprfloat";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/0.53";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprpicker.url = "github:hyprwm/hyprpicker";
    impermanence.url = "github:nix-community/impermanence";
    import-tree.url = "github:vic/import-tree";
    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mobile-nixos = {
      url = "github:mobile-nixos/mobile-nixos";
      flake = false;
    };
    nimBytesized = {
      url = "gitlab:Maxb0tbeep/bytesized";
      flake = false;
    };
    nimElvis = {
      url = "github:mattaylor/elvis";
      flake = false;
    };
    nimTermstyle = {
      url = "github:PMunch/termstyle";
      flake = false;
    };
    nimYaml = {
      url = "github:flyx/NimYAML";
      flake = false;
    };
    nix-alien.url = "https://flakehub.com/f/thiagokokada/nix-alien/0.1";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-doom-emacs-unstraightened = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-search-tv.url = "github:3timeslazy/nix-search-tv";
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs = {
        flake-compat.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
    nixvim.url = "github:nix-community/nixvim";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    ponysay.url = "github:CrystalSplitter/ponysay-modern";
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
    pyprland.url = "github:hyprland-community/pyprland";
    rofi-tools.url = "github:szaffarano/rofi-tools";
    sdm845-linux = {
      url = "https://codeberg.org/sdm845/linux/archive/25be2fc4eabe9666f78cc3ec80b938fe2d92efea.tar.gz";
      flake = false;
    };
    swiftfetch = {
      url = "github:ly-sec/swiftfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tachyon-patches = {
      url = "https://git.staropensource.de/StarOpenSource/Linux-Tachyon/archive/465087d9f514ffebcfda87ae9ec184e843616313.tar.gz";
      flake = false;
    };
    tmux-cowboy = {
      url = "github:tmux-plugins/tmux-cowboy/75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
      flake = false;
    };
    tmux-menus = {
      url = "github:jaclu/tmux-menus/764ac9cd6bbad199e042419b8074eda18e9d8b2d";
      flake = false;
    };
    tmux-named-snapshot = {
      url = "github:spywhere/tmux-named-snapshot/872fedef62c1b732a56ca643f2354346912e06c3";
      flake = false;
    };
    tmux-notify = {
      url = "github:rickstaa/tmux-notify/75702b6d0a866769dd14f3896e9d19f7e0acd4f2";
      flake = false;
    };
    tmux-power-zoom = {
      url = "github:jaclu/tmux-power-zoom/6d618af224229ae653ffcc6d12c2146d536af79b";
      flake = false;
    };
    tmux-suspend = {
      url = "github:MunifTanjim/tmux-suspend/1a2f806666e0bfed37535372279fa00d27d50d14";
      flake = false;
    };
    uwe5622 = {
      url = "github:Ran-Thegoth/uwe5622";
      flake = false;
    };
    xrlinux = {
      url = "github:wheaney/XRLinuxDriver";
      flake = false;
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
