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
      "blake3-hashes"
      "ca-derivations"
      "fetch-closure"
      "flakes"
      "git-hashing"
      "nix-command"
      "parse-toml-timestamps"
      "pipe-operators"
      "verified-fetches"
    ];
    extra-substituters = [ ];
    extra-trusted-public-keys = [ ];
    lazy-trees = true;
    submodules = true;
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://vanilla-mobile-nixos.cachix.org"
      "https://cache.xinux.uz"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "vanilla-mobile-nixos.cachix.org-1:nicMQxxTD4n6PM9dCvylqsCOCA6M2C6gybbCKrei8AQ="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
    ];
    trusted-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://install.determinate.systems"
    ];
    use-xdg-base-directories = true;
  };

  inputs = {
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
    app-manager = {
      url = "github:ASHWIN990/app-manager";
      flake = false;
    };
    appimage-thumbnailer = {
      url = "github:realmazharhussain/appimage-thumbnailer";
      flake = false;
    };
    armbian = {
      url = "github:armbian/build";
      flake = false;
    };
    armbian-firmware = {
      url = "github:armbian/firmware";
      flake = false;
    };
    asus = {
      url = "gitlab:asus-linux/linux-g14/c95c77b20d794c1c962fcccc9735348bdb7d4e76";
      flake = false;
    };
    autoricer = {
      url = "github:3rfaan/autoricer";
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
    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    cachyos-patches = {
      url = "github:CachyOS/kernel-patches";
      flake = false;
    };
    cachyos-patches-unsync = {
      url = "github:CachyOS/kernel-patches/c1ba300617a12d257b5721572b9bbe28efae182f";
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
    cemetery-escape = {
      url = "github:tom-on-the-internet/cemetery-escape";
      flake = false;
    };
    chalk-animation = {
      url = "github:bokub/chalk-animation";
      flake = false;
    };
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cli-of-life = {
      url = "github:gabe565/cli-of-life";
      flake = false;
    };
    clidle = {
      url = "github:ajeetdsouza/clidle";
      flake = false;
    };
    cliwrap = {
      url = "github:islemci/cliwrap";
      flake = false;
    };
    compress = {
      url = "github:benapetr/compress";
      flake = false;
    };
    conway-screensaver = {
      url = "github:cdkw2/conway-screensaver";
      flake = false;
    };
    copyparty.url = "github:9001/copyparty";
    corrupter = {
      url = "github:r00tman/corrupter";
      flake = false;
    };
    custom-packages.url = "github:Rishabh5321/custom-packages-flake";
    customfetch = {
      url = "github:Toni500github/customfetch";
      flake = false;
    };
    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    davinci-video-converter = {
      url = "github:tkmxqrdxddd/davinci-video-converter";
      flake = false;
    };
    den.url = "github:denful/den";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    disko.url = "github:nix-community/disko";
    disko-mobile = {
      url = "github:JuneStepp/disko/mobile";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    diskonaut = {
      url = "github:imsnif/diskonaut";
      flake = false;
    };
    dockadvisor = {
      url = "github:deckrun/dockadvisor";
      flake = false;
    };
    dockerfilegraph = {
      url = "github:patrickhoefler/dockerfilegraph";
      flake = false;
    };
    dprs = {
      url = "github:durableprogramming/dprs";
      flake = false;
    };
    dunst-timer = {
      url = "github:bitSheriff/dunst-timer";
      flake = false;
    };
    dvdbounce = {
      url = "github:George-lewis/DVDBounce";
      flake = false;
    };
    dvdts = {
      url = "github:ForumPlayer/dvdts";
      flake = false;
    };
    elia-chat = {
      url = "github:darrenburns/elia";
      flake = false;
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    endcord = {
      url = "github:sparklost/endcord";
      flake = false;
    };
    envfetch = {
      url = "github:ankddev/envfetch";
      flake = false;
    };
    ext4-crypt = {
      url = "github:gdelugre/ext4-crypt";
      flake = false;
    };
    ffmpeg-audio-thumbnailer = {
      url = "github:saltedcoffii/ffmpeg-audio-thumbnailer";
      flake = false;
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
    fman = {
      url = "github:nore-dev/fman";
      flake = false;
    };
    fortune-anti-jokes = {
      url = "github:dh-nunes/fortune-anti-jokes";
      flake = false;
    };
    fortune-mod-anarchism = {
      url = "http://deb.debian.org/debian/pool/main/b/blag-fortune/blag-fortune_1.9.0.orig.tar.gz";
      flake = false;
    };
    fortune-mod-archlinux = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/archlinux?h=fortune-mod-archlinux";
      flake = false;
    };
    fortune-mod-billwurtz = {
      url = "github:Ev1lbl0w/fortune-mod-billwurtz";
      flake = false;
    };
    fortune-mod-bofh-excuses = {
      url = "http://pages.cs.wisc.edu/~ballard/bofh/excuses";
      flake = false;
    };
    fortune-mod-calvin = {
      url = "http://www.netmeister.org/misc.html";
      flake = false;
    };
    fortune-mod-canada-nctr = {
      url = "github:mikebirdgeneau/fortune-mod-canada-nctr";
      flake = false;
    };
    fortune-mod-confucius = {
      url = "https://billy.wolfe.casa/fortunes/confucius";
      flake = false;
    };
    fortune-mod-darkknight = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/darkknight?h=fortune-mod-darkknight";
      flake = false;
    };
    fortune-mod-dhammapada = {
      url = "https://gitlab.com/bodhi.zazen/display-dhammapada/-/archive/main/display-dhammapada-main.tar.gz";
      flake = false;
    };
    fortune-mod-doctorwho-classic-series = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/doctorwho-classic-series?h=fortune-mod-doctorwho-classic-series";
      flake = false;
    };
    fortune-mod-doctorwho-new-series = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/doctorwho-new-series?h=fortune-mod-doctorwho-new-series";
      flake = false;
    };
    fortune-mod-futurama = {
      url = "http://www.netmeister.org/apps/fortune-mod-futurama-0.2.tar.gz";
      flake = false;
    };
    fortune-mod-g = {
      url = "github:ketogenesis/gfortune";
      flake = false;
    };
    fortune-mod-issa-haiku = {
      url = "http://www.tastyrabbit.net/issa-haiku.tar.gz";
      flake = false;
    };
    fortune-mod-leftism = {
      url = "github:anakojm/leftist-quote";
      flake = false;
    };
    fortune-mod-limetricks = {
      url = "https://billy.wolfe.casa/fortunes/limericks";
      flake = false;
    };
    fortune-mod-matrix = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/fortunes.txt?h=fortune-mod-matrix";
      flake = false;
    };
    fortune-mod-portal-game = {
      url = "github:outadoc/portal-fortunes";
      flake = false;
    };
    fortune-mod-protolol = {
      url = "github:virtualtam/fortune-protolol";
      flake = false;
    };
    fortune-mod-question-answer-jokes = {
      url = "https://billy.wolfe.casa/fortunes/question-answer-jokes";
      flake = false;
    };
    fortune-mod-starwars = {
      url = "http://www.splitbrain.org/_media/projects/fortunes/fortune-starwars.tgz";
      flake = false;
    };
    fortune-mod-vimtips = {
      url = "https://raw.githubusercontent.com/hobbestigrou/vimtips-fortune/master/fortunes/vimtips";
      flake = false;
    };
    fortunes-es = {
      url = "http://ftp.es.debian.org/debian/pool/main/f/fortunes-es/fortunes-es_1.36+nmu1.tar.xz";
      flake = false;
    };
    frenzch = {
      url = "github:FrenzyExists/frenzch.sh";
      flake = false;
    };
    gestures.url = "github:ferstar/gestures";
    go-life = {
      url = "github:sachaos/go-life";
      flake = false;
    };
    gof-rs = {
      url = "github:omagdy7/gof-rs";
      flake = false;
    };
    goto = {
      url = "github:grafviktor/goto";
      flake = false;
    };
    gspot = {
      url = "github:abs3ntdev/gspot";
      flake = false;
    };
    helluva-beelzebub = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/beelzebub?h=fortune-mod-helluva";
      flake = false;
    };
    helluva-blitz = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/blitz?h=fortune-mod-helluva";
      flake = false;
    };
    helluva-loona = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/loona?h=fortune-mod-helluva";
      flake = false;
    };
    helluva-millie = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/millie?h=fortune-mod-helluva";
      flake = false;
    };
    helluva-moxxie = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/moxxie?h=fortune-mod-helluva";
      flake = false;
    };
    hexfetch = {
      url = "github:hexisXz/hexfetch";
      flake = false;
    };
    hf = {
      url = "github:sorairolake/hf";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    husse-funny = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/husse-funny?h=fortune-mod-husse";
      flake = false;
    };
    husse-helping = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/husse-helping?h=fortune-mod-husse";
      flake = false;
    };
    husse-moderating = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/husse-moderating?h=fortune-mod-husse";
      flake = false;
    };
    husse-self = {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/husse-self?h=fortune-mod-husse";
      flake = false;
    };
    hwfetch = {
      url = "github:rosymati/hwfetch";
      flake = false;
    };
    hypr-input-switcher = {
      url = "github:icyleaf/hypr-input-switcher";
      flake = false;
    };
    hypr-zoom = {
      url = "github:FShou/hypr-zoom";
      flake = false;
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
    jar-thumbnailer = {
      url = "github:realmazharhussain/jar-thumbnailer";
      flake = false;
    };
    jdownloader = {
      url = "https://installer.jdownloader.org/JDownloader.jar";
      flake = false;
    };
    journalview = {
      url = "github:codervijo/journalview";
      flake = false;
    };
    jwt-ui = {
      url = "github:jwt-rs/jwt-ui";
      flake = false;
    };
    kMenu = {
      url = "github:51n7/kMenu";
      flake = false;
    };
    kat-oh = {
      url = "github:aryvector/kat-oh";
      flake = false;
    };
    kde-control-station = {
      url = "github:EliverLara/kde-control-station";
      flake = false;
    };
    kde-thumbnailer-apk = {
      url = "github:z3ntu/kde-thumbnailer-apk";
      flake = false;
    };
    kwin-effects-better-blur-dx = {
      url = "github:xarblu/kwin-effects-better-blur-dx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kyun = {
      url = "github:lennart-finke/kyun";
      flake = false;
    };
    kzones = {
      url = "github:gerritdevriese/kzones";
      flake = false;
    };
    layan-kde = {
      url = "github:vinceliuice/layan-kde";
      flake = false;
    };
    lazysys = {
      url = "github:XhuyZ/lazysys";
      flake = false;
    };
    lifecycler = {
      url = "github:cxreiff/lifecycler";
      flake = false;
    };
    linux-config = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };
    linux-latest = {
      url = "github:CachyOS/linux/cachyos-7.2.2-1";
      flake = false;
    };
    linux-lts = {
      url = "github:CachyOS/linux/cachyos-6.18.48-2";
      flake = false;
    };
    linuxthemestore = {
      url = "github:debasish-patra-1987/linuxthemestore";
      flake = false;
    };
    loc = {
      url = "github:cgag/loc";
      flake = false;
    };
    logcat-color3 = {
      url = "github:yan12125/logcat-color3";
      flake = false;
    };
    loop = {
      url = "github:Miserlou/loop";
      flake = false;
    };
    lxtui = {
      url = "github:FoleyBridge-Solutions/lxtui";
      flake = false;
    };
    lyricstify = {
      url = "github:lyricstify/lyricstify";
      flake = false;
    };
    m4-utils = {
      url = "gitlab:nobodyinperson/m4-utils";
      flake = false;
    };
    mabel = {
      url = "github:smmr-software/mabel";
      flake = false;
    };
    macos-kvm = {
      url = "github:Coopydood/ultimate-macOS-KVM";
      flake = false;
    };
    maxwell = {
      url = "github:wilversings/maxwell";
      flake = false;
    };
    memavaild = {
      url = "github:hakavlad/memavaild";
      flake = false;
    };
    mfetch = {
      url = "github:xdearboy/mfetch";
      flake = false;
    };
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mynav = {
      url = "github:GianlucaP106/mynav";
      flake = false;
    };
    ncmatrix = {
      url = "github:tree-s/ncmatrix";
      flake = false;
    };
    neo = {
      url = "github:st3w/neo";
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
    nitronx = {
      url = "github:UsiFX/OpenNitroN";
      flake = false;
    };
    nix-alien.url = "https://flakehub.com/f/thiagokokada/nix-alien/0.1";
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
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs-gtk2.url = "github:NixOS/nixpkgs/48199e04590301db3a47603919037df65c828797";
    nixpkgs-qemu9.url = "github:NixOS/nixpkgs/fcb54ddcc974cff59bdfb7c1ac9e080299763d2d";
    nixpkgs-wine.url = "github:NixOS/nixpkgs/a1945f760a8fe019a4d753808de424dcd4e5b3cf";
    nixvim.url = "github:nix-community/nixvim";
    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    no-more-secrets = {
      url = "github:bartobri/no-more-secrets";
      flake = false;
    };
    oneplus = {
      url = "gitlab:sdm845-mainline/firmware-oneplus-sdm845/176ca713448c5237a983fb1f158cf3a5c251d775";
      flake = false;
    };
    osx-kvm = {
      url = "github:kholia/OSX-KVM";
      flake = false;
    };
    paclear = {
      url = "github:orangekame3/paclear";
      flake = false;
    };
    panel-spacer-extended = {
      url = "github:luisbocanegra/plasma-panel-spacer-extended";
      flake = false;
    };
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    pkgtop = {
      url = "github:orhun/pkgtop";
      flake = false;
    };
    plasma-gamemode = {
      url = "github:orhun/pkgtop";
      flake = false;
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
    };
    ponysay.url = "github:CrystalSplitter/ponysay-modern";
    procmux = {
      url = "github:napisani/procmux";
      flake = false;
    };
    pyprland.url = "github:hyprland-community/pyprland";
    q6voiced = {
      url = "gitlab:postmarketOS/q6voiced/736138bfc9f7b455a96679e2d67fd922a8f16464";
      flake = false;
    };
    rbonsai = {
      url = "github:roberte777/rbonsai";
      flake = false;
    };
    rofi-process-killer = {
      url = "github:madhur/rofi-process-killer";
      flake = false;
    };
    rofi-tmux = {
      url = "github:viniarck/rofi-tmux";
      flake = false;
    };
    rofi-tools.url = "github:szaffarano/rofi-tools";
    runlike = {
      url = "github:lavie/runlike";
      flake = false;
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sandscreen = {
      url = "github:frostyarchtide/sandscreen";
      flake = false;
    };
    scrcpy-wrapper = {
      url = "github:Bluemangoo/scrcpy-wrapper";
      flake = false;
    };
    screego = {
      url = "github:screego/server";
      flake = false;
    };
    sdm845-alsa = {
      url = "gitlab:sdm845-mainline/alsa-ucm-conf/aaa7889f7a6de640b4d78300e118457335ad16c0";
      flake = false;
    };
    sdm845-config = {
      url = "https://gitlab.com/sdm845-mainline/linux/-/raw/sdm845-7.1-rc1-r0/arch/arm64/configs/sdm845.config?ref_type=tags";
      flake = false;
    };
    sdm845-defconfig = {
      url = "https://gitlab.com/sdm845-mainline/linux/-/raw/sdm845-7.1-rc1-r0/arch/arm64/configs/defconfig?ref_type=tags";
      flake = false;
    };
    sdm845-misc = {
      url = "https://gitlab.com/sdm845-mainline/linux/-/raw/sdm845-7.1-rc1-r0/arch/arm64/configs/misc.config?ref_type=tags";
      flake = false;
    };
    sha256-animation = {
      url = "github:in3rsha/sha256-animation";
      flake = false;
    };
    socktop = {
      url = "github:jasonwitty/socktop";
      flake = false;
    };
    songfetch = {
      url = "github:ekrlstd/songfetch";
      flake = false;
    };
    spofi = {
      url = "github:davidborzek/spofi";
      flake = false;
    };
    spotitube = {
      url = "github:streambinder/spotitube";
      flake = false;
    };
    ssh-list = {
      url = "github:akinoiro/ssh-list";
      flake = false;
    };
    sticky-window-snapping = {
      url = "github:Flupp/sticky-window-snapping";
      flake = false;
    };
    supdock = {
      url = "github:segersniels/supdock";
      flake = false;
    };
    swiftfetch = {
      url = "github:ly-sec/swiftfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sxtetris = {
      url = "github:shixinhuang99/sxtetris";
      flake = false;
    };
    sysfex = {
      url = "github:mehedirm6244/sysfex";
      flake = false;
    };
    t2-audio = {
      url = "github:kekrby/t2-better-audio/e46839a28963e2f7d364020518b9dac98236bcae";
      flake = false;
    };
    t2fanrd = {
      url = "github:GnomedDev/T2FanRD/85027878e4d7fa0170fea1213d6f8dd972d60e83";
      flake = false;
    };
    tablet-map = {
      url = "github:victor7w7r/tablet_map";
      flake = false;
    };
    tachyon-patches-latest = {
      url = "https://git.staropensource.de/StarOpenSource/Linux-Tachyon/archive/25bfa5ba12783e5e1b0a15cfac570b532f711329.tar.gz";
      flake = false;
    };
    tachyon-patches-lts = {
      url = "https://git.staropensource.de/StarOpenSource/Linux-Tachyon/archive/bab8787a6987ad7b38e39c4d6bbc75315a44329a.tar.gz";
      flake = false;
    };
    termsaver = {
      url = "github:brunobraga/termsaver";
      flake = false;
    };
    tewi = {
      url = "github:anlar/tewi";
      flake = false;
    };
    texoxide = {
      url = "github:arxari-archive/texoxide";
      flake = false;
    };
    thunar-custom-actions = {
      url = "gitlab:nobodyinperson/thunar-custom-actions";
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
    treefetch = {
      url = "github:angelofallars/treefetch";
      flake = false;
    };
    tui-slides = {
      url = "github:Chleba/tui-slides";
      flake = false;
    };
    tuifimanager = {
      url = "github:GiorgosXou/TUIFIManager";
      flake = false;
    };
    tuime = {
      url = "github:nthnd/tuime";
      flake = false;
    };
    updo = {
      url = "github:Owloops/updo";
      flake = false;
    };
    uwe5622 = {
      url = "github:armbian/uwe5622";
      flake = false;
    };
    vanilla-mobile-nixos.url = "github:vanilla-mobile-nixos/vanilla-mobile-nixos";
    virtual-desktops-only-on-primary = {
      url = "github:Ubiquitine/virtual-desktops-only-on-primary";
      flake = false;
    };
    wallpaper-effects = {
      url = "github:luisbocanegra/plasma-wallpaper-effects/refs/tags/v2.0.0";
      flake = false;
    };
    waybar-dunst = {
      url = "github:CelDaemon/waybar-dunst";
      flake = false;
    };
    waybar-media = {
      url = "github:yurihs/waybar-media";
      flake = false;
    };
    ytdl = {
      url = "github:codewithmoss/ytdl";
      flake = false;
    };
    zeitfetch = {
      url = "github:nidnogg/zeitfetch";
      flake = false;
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zilch = {
      url = "github:lavafroth/zilch";
      flake = false;
    };
  };
}
