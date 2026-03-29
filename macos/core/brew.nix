{ lib, ... }:
let   mkGreedy = caskName: { name = caskName; greedy = true; }; in
{
  homebrew = {
    enable = true;
    caskArgs = {
      appdir = "~/Applications";
      require_sha = true;
      no_quarantine = true;
    };
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      #cleanup = "uninstall";
      extraFlags = [ "--verbose" ];
    };
    global = {
      autoUpdate = true;
      brewfile = true;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];

/*    masApps = {
      "Amphetamine" = 937984704;
      "Apple Configurator" = 1037126344;
      "CCMenu" = 603117688;
      "DrCleaner" = 921458519;
      "Xcode" = 497799835;
      "Unzip One" = 1127253508;
    };
*/
    casks = lib.map mkGreedy [
      "alt-tab"
      "applite"
      "app-cleaner"
      "appcleaner"
      "codeedit"
      "cool-retro-term"
      "coteditor"
      "devtoys"
      "dockdoor"
      "go2shell"
      "gsmartcontrol"
      "hiddenbar"
      "jordanbaird-ice"
      "jdownloader"
      "loop"
      "lulu"
      "macs-fan-control"
      "maccy"
      "mist"
      "mounty"
      "onlyoffice"
      "onyx"
      "openmtp"
      "parallels-client"
      "pearcleaner"
      "qview"
      "qlvideo"
      "sketch"
      "stats"
      "turbo-boost-switcher"
      "vlc"
      "zed"
      "zen"
    ];

    brews = [
      "abdfnx/tap/tran"
      "cfoust/taps/cy"
      "Code-Hex/tap/neo-cowsay"
      "danielgatis/imgcat/imgcat"
      "danvergara/tools/dblab"
      "f1bonacc1/tap/process-compose"
      "gromgit/fuse/sshfs-mac"
      "gromgit/fuse/ntfs-3g-mac"
      "itchyny/tap/mmv"
      "kdabir/tap/has"
      "mananapr/cfiles/cfiles"
      #"nakabonne/pbgopy/pbgopy"
      "napisani/procmux"
      "orangekame3/tap/paclear"
      "qnkhuat/tap/termishare"
      "tako8ki/tap/gobang"
      "yudai/gotty/gotty"
      "android-platform-tools"
      "arttime"
      "apparency"
      "bfg"
      "cfonts"
      "diskonaut"
      "dua-cli"
      "macfuse"
      "mabel"
      "mas"
      "meli"
      "midnight-commander"
      "nmail"
      "nvtop"
      "ossp-uuid"
      "openssl"
      "pipes- sh"
      "progressline"
      "pyenv-virtualenv"
      "qlcolorcode"
      "qlstephen"
      "qlmarkdown"
      "quicklook-json"
      "quicklookase"
      "qlvideo"
      "sevenzip"
      "suspicious-package"
      "tmux-xpanes"
      "thefuck"
    ];
  };
}
