{ ... }:
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
