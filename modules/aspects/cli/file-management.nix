{
  den.aspects.cli.file-management = {
    os =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          clifm
          lf
          joshuto
          superfile
          termscp
          tran
          trash-cli
          walk
        ];
        programs.yazi = {
          enable = true;
        };
      };

    nixos =
      { self', ... }:
      {
        environment.systemPackages = with self'.packages; [
          fman
          tuifimanager
        ];
      };

    provides.to-users.homeManager.programs = {
      broot.enable = true;
      mc.enable = true;
      nnn.enable = true;
      vifm.enable = true;
      xplr.enable = true;
    };
  };
}
