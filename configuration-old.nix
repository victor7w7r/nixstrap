{
  config,
  pkgs,
  inputs,
  username,
  hostname,
  ...
}:

{
  #imports = [ ./hardware-configuration.nix ];

  fonts = {
    packages = (
      with pkgs;
      [
        noto-fonts
        noto-fonts-extra
        noto-fonts-cjk-sans
        noto-fonts-emoji
        fira-code
        fira-code-symbols
        dina-font
        proggyfonts
        udev-gothic-nf
        font-awesome
        cantarell-fonts
      ]
    );

    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [
          "Noto Sans CJK JP"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif JP"
          "DejaVu Serif"
        ];
      };
      subpixel = {
        lcdfilter = "light";
      };
    };
  };

  services.xserver.enable = true;
  services.seatd.enable = false;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  services.fwupd.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [
      "wheel"
      "video"
      "input"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  # programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.git.enable = true;
  # https://nix.dev/guides/faq#how-to-run-non-nix-executables
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ nix-index ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
