{
  flake-file.inputs = {
    batfetch = {
      url = "github:ashish-kus/batfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swiftfetch = {
      url = "github:ly-sec/swiftfetch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.misc.fetch = {
    os =
      { pkgs, self', ... }:
      {
        environment.systemPackages =
          with pkgs;
          with self'.packages;
          [
            cargofetch
            countryfetch
            customfetch
            envfetch
            freshfetch
            macchina
            nerdfetch
            octofetch
            onefetch
            pfetch-rs
            uwufetch
            treefetch
          ];
      };

    nixos =
      {
        #inputs',
        pkgs,
        #host,
        self',
        ...
      }:
      {
        environment.systemPackages =
          with pkgs;
          with self'.packages;
          [
            cpufetch
            microfetch
            ramfetch
            bestfetch
            frenzch
            hexfetch
            hwfetch
            kat-oh
            mfetch
            songfetch
            sysfex
            zeitfetch
            #inputs'.batfetch.packages.${host.system}.default
            #inputs.swiftfetch.packages.${pkgs.system}.swiftfetch
          ];
      };

    provides.to-users.homeManager.programs.fastfetch = {
      enable = true;
    };
  };
}
