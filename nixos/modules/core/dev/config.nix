{ ... }:
{
  programs = {
    #aichat.enable = true;
    #aider-chat.enable = true;
    ccache = {
      enable = true;
      cacheDir = "/nix/var/cache/ccache";
    };
    direnv = {
      enable = false;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
