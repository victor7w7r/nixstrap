{ ... }:
{
  programs = {
    bottom.enable = true;
    broot.enable = true;
    fastfetch.enable = true;
    nnn.enable = true;
    navi.enable = true;
    tealdeer.enable = true;
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      defaultOptions = [
        "--height 40%"
        "--reverse"
        "--border"
        "--color=16"
      ];
      defaultCommand = "rg --files --hidden --glob=!.git/";
    };
    hwatch.enable = true;
    fd.enable = true;
    mc.enable = true;
    #lazydocker.enable = true;
    looking-glass-client.enable = true;
    lsd.enable = true;
    pyenv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
    ripgrep-all.enable = true;
    rclone.enable = true;
    vifm.enable = true;
    xplr.enable = true;
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      options = [ "--cmd cd" ];
    };
    eza = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      colors = "always";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--no-quotes"
      ];
    };
  };
}
