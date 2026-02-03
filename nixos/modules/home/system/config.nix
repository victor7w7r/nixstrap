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
    ripgrep-all.enable = true;
    rclone.enable = true;
    vifm.enable = true;
    xplr.enable = true;
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
      #enableZshIntegration = true;
    };

    eza = {
      enable = true;
      #enableZshIntegration = true;
      colors = "always";
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--no-quotes"
      ];
    };
  };
}
