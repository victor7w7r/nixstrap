{ ... }:
{
  programs = {
    #aichat.enable = true;
    #aider-chat.enable = true;

    direnv = {
      enable = true;
      #enableZshIntegration = true;
      nix-direnv.enable = true;
    };

  };
}
