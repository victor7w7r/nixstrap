{ pkgs, ... }:
{
  programs = {
    broot.enable = true;
    bat = {
      enable = true;
      config = {
        theme = "base16";
        "italic-text" = "always";
        style = "numbers";
      };
    };
    btop = {
      enable = true;
      settings = {
        color_theme = "dracula";
        theme_background = false;
        update_ms = 500;
      };
    };
    difftastic = {
      enable = true;
      git.enable = true;
      options.background = "dark";
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
    gitui.enable = true;
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
    hwatch.enable = true;
    nnn.enable = true;
    ripgrep-all.enable = true;
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
    navi.enable = true;
    tealdeer.enable = true;
    visidata.enable = true;
    vifm.enable = true;
    xplr.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      enableBashCompletion = true;
      interactiveShellInit = ''
        # Todo move to homemanager/darwin section
        export PATH="/opt/homebrew/opt/postgresql@12/bin:$PATH"
        export PATH="/opt/homebrew/bin:$PATH"
        export PATH="/$HOME/.rd/bin:$PATH"
        ulimit -n 4096
      '';
    };
  };
}
