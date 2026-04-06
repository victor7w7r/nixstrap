{ ... }:
{
  nix.settings.extra-sandbox-paths = [ "/var/cache/ccache" ];
  programs = {
    #aichat.enable = true;
    #aider-chat.enable = true;
    ccache = {
      enable = true;
      cacheDir = "/var/cache/ccache";
    };
    direnv = {
      enable = false;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
