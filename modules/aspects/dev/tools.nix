{
  den.aspects.dev.tools = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          tracexec
          #elia-chat
          #dblab
          #gobang
        ];
      };

    os =
      { pkgs, self', ... }:
      {
        environment.systemPackages = with pkgs; [
          atac
          dos2unix
          curlie
          httpie
          fw
          jless
          just
          self'.packages.jwtui
          ktlint
          self'.packages.kyun
          self'.packages.loc
          self'.packages.mynav
          posting
          rainfrog
          shellcheck
          ugm
          self'.packages.updo
          xh
        ];
        programs.direnv = {
          enable = false;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
      };

    homeManager.programs = {
      #aichat.enable = true;
      #aider-chat.enable = true;
      #meli.enable = true; BUILD
      #visidata.enable = true;
      gitui.enable = true;
      jq.enable = true;
      lazysql.enable = true;
      mods.enable = true;
      pyenv = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
      };
    };
  };
}
