{
  den.aspects.cli.extras = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          cheat
          cmd-wrapped
          emptty
          modprobed-db
          glow
          inotify-tools
          jump
          sampler
          seadrive-fuse
          seafile-shared
          viddy
          vtm
          wtfutil
        ];
        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
          pinentryPackage = pkgs.pinentry-tty;
        };
      };

    provides.to-users.homeManager = {
      services.pueue.enable = true;
      programs = {
        tealdeer.enable = true;
        bottom.enable = true;
        navi.enable = true;
        hwatch.enable = true;
        topgrade.enable = true;
        asciinema.enable = true;
        rtorrent.enable = true;
      };
    };
  };
}
