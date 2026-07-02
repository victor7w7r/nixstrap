{
  flake-file.inputs = {
    hyprland.url = "https://flakehub.com/f/hyprwm/Hyprland/0.53";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprfloat = {
      url = "github:nevimmu/hyprfloat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprdvd = {
      url = "github:nevimmu/hyprdvd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rofi-tools.url = "github:szaffarano/rofi-tools";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    pyprland.url = "github:hyprland-community/pyprland";
  };

  den.aspects.hyprland.provides.to-users.homeManager =
    {
      host,
      inputs',
      pkgs,
      self',
      ...
    }:
    {
      imports = [
        inputs'.hyprfloat.homeManagerModules.default
        inputs'.hyprdvd.homeManagerModules.default
      ];

      home.packages = with pkgs; [
        #pyprland.packages."x86_64-linux".pyprland
        inputs'.rofi-tools.packages.${host.system}.default
        brightnessctl
        dmenu-rs
        figlet
        hyprdim
        hyprland-qtutils
        hyprlock
        hyprpicker
        hyprfreeze
        hyprmon
        hyprnome
        hyprutils
        hyprviz
        grimblast
        rofi-bluetooth
        rofi-calc
        rofi-emoji
        rofi-power-menu
        rofimoji
        slurp
        swaybg
        swaylock-effects
        swaylock-fancy
        waybar-lyric # waybar-cava enable
        wl-clip-persist
        wf-recorder
        glib
        rofi-file-browser
        self'.packages.autoricer
        self'.packages.corrupter
        self'.packages.dunst-timer
        self'.packages.hyprmixer
        self'.packages.hypr-input-switcher
        self'.packages.hypr-zoom
        self'.packages.rofi-process-killer
        self'.packages.rofi-tmux
        self'.packages.spofi
        self'.packages.waybar-dunst
        self'.packages.waybar-media
        #https://github.com/newmanls/rofi-themes-collection - userscript
      ];

      systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];

      services = {
        cliphist.enable = true;
        dunst.enable = true;
        hypridle.enable = true;
        hyprpolkitagent.enable = true;
        hyprpaper.enable = true;
        hyprshell.enable = true;
        #hyprshot.enable = true;
        hyprsunset.enable = true;
        network-manager-applet.enable = true;
        wob.enable = true;
      };

      programs = {
        wlogout.enable = true;
        #uwsm.enable = true;
        bemenu.enable = true;
        #iio-hyprland.enable = true;
        tofi.enable = true;
        waybar.enable = true;
      };

      wayland.windowManager.hyprland = {
        systemd.enable = true;
        enable = true;
        xwayland.enable = true;
        plugins = [
          pkgs.hyprlandPlugins.hyprgrass
        ];
      };
    };
}
