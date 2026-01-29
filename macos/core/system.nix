{
  host,
  user,
  inputs,
  pkgs,
  ...
}:
{
  system.primaryUser = user;
  time.timeZone = "Aamerica/Guayaquil";

  networking = {
    computerName = host;
    localHostName = host;
    hostName = host;
    applicationFirewall = {
      enable = true;
      blockAllIncoming = false;
      allowSigned = true;
      allowSignedApp = true;
      enableStealthMode = false;
    };
  };

  environment = {
    loginShell = pkgs.zsh;
    variables.RLIMIT_NOFILE = "65536";
    pathsToLink = [ "/Applications" ];
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${pkgs.path}";
      stable.source = "${inputs.stable}";
      "sudoers.d/timeout".text = ''
        Defaults timestamp_timeout=30
      '';
      "gitconfig".text = ''
          [filter "lfs"]
            clean = git-lfs clean -- %f
            smudge = git-lfs smudge -- %f
            process = git-lfs filter-process
            required = true
        '';

    };
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
  ];

  programs = {
    bandwhich.enable = true;
    less.enable = true;
    skim.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    bottom.enable = true;
    yazi = {
      enable = true;
      /*
        settings.manager = {
        show_hidden = true;
        show_symlink = true;
        };
      */
    };
  };

  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    shell = pkgs.zsh;
  };
}
