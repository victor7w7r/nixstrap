{ ... }:
{
  nix.settings.extra-sandbox-paths = [
    "/nix/var/cache/ccache-kernel"
  ];
  programs = {
    #aichat.enable = true;
    #aider-chat.enable = true;
    ccache = {
      enable = true;
      cacheDir = "/nix/var/cache/ccache-kernel";
      extraConfig = ''
        compression = false
        file_clone = true
        max_size = 25G
        sloppiness = random_seed
        umask = 007
        compiler_check = content
      '';
    };
    direnv = {
      enable = false;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
