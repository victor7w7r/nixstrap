{
  den.default.provides.to-users.homeManager = { pkgs, self', ... }: {
    home.packages =
      with pkgs;
      pkgs.symlinkJoin {
        name = "fortune-cookies";
        paths = with self'.packages; [
          pkgs.fortune
          fortune-anti-jokes
          fortune-mod-archlinux
          fortune-mod-anarchism
          fortune-mod-bofh-excuses
          fortune-mod-billwurtz
          fortune-mod-canada-nctr
          fortune-mod-calvin
          fortune-mod-confucius
          fortune-mod-darkknight
          fortune-mod-dhammapada
          fortune-mod-doctorwho-classic-series
          fortune-mod-doctorwho-new-series
          fortune-mod-es
          fortune-mod-futurama
          fortune-mod-g
          fortune-mod-helluva
          fortune-mod-husse
          fortune-mod-issa-haiku
          fortune-mod-leftism
          fortune-mod-limetricks
          fortune-mod-matrix
          fortune-mod-portal-game
          fortune-mod-protolol
          fortune-mod-starwars
          fortune-mod-vimtips
        ];
      }
      |> (cookies: [
        (pkgs.writeShellScriptBin "fortune" ''
          exec ${
            pkgs.fortune.override { withOffensive = true; }
          }/bin/fortune -s "${cookies}/share/games/fortunes" "$@"
        '')
      ]);
  };
}
