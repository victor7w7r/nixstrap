{ ... }:
{
  nix.settings.extra-sandbox-paths = [
    "/nix/var/cache/ccache"
    "/nix/var/cache/sccache"
  ];
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
