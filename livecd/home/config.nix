{ pkgs, ... }:
{
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "dracula";
        theme_background = false;
        update_ms = 500;
      };
    };
    git = {
      enable = true;
      lfs.enable = true;
      userName = "victor7w7r";
      userEmail = "arkano036@gmail.com";
      settings = {
        core.pager = "${pkgs.delta}/bin/delta";
        init.defaultBranch = "main";
        credential.helper = "store";
        mergetool.prompt = true;
        rebase.autostash = true;
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };
    fastfetch.enable = true;
    fzf = {
      enable = true;
      defaultOptions = [
        "--height 40%"
        "--reverse"
        "--border"
        "--color=16"
      ];
      defaultCommand = "rg --files --hidden --glob=!.git/";
    };
    nnn.enable = true;
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
      enableZshIntegration = true;
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      colors = "always";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--no-quotes"
      ];
    };
  };
}
