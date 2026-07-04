{ inputs, ... }:
{
  flake-file.inputs = {
    nix-alien.url = "https://flakehub.com/f/thiagokokada/nix-alien/0.1";
    nix-search-tv.url = "github:3timeslazy/nix-search-tv";
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };
  };

  den.default = {
    os =
      { pkgs, self', ... }:
      {
        environment.systemPackages = with pkgs; [
          alejandra
          cached-nix-shell
          comma
          cachix
          deadnix
          lorri
          manix
          namaka
          niv
          nix-diff
          nix-du
          nix-health
          nix-init
          nix-melt
          nix-output-monitor
          nix-search-cli
          nix-tree
          nix-update
          nixfmt
          nvd
          optnix
          statix
          self'.packages.pkgtop
        ];
      };

    nixos =
      { pkgs, ... }:
      {
        #imports = [ inputs.nix-search-tv.packages.x86_64-linux.default ];
        environment.systemPackages = [
          #inputs.nix-alien.packages.${system}.nix-alien
        ];
      };

    provides.to-users.homeManager = {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];

      programs = {
        nix-index-database.comma.enable = true;
        nix-index = {
          enable = true;
          enableZshIntegration = true;
        };
      };
    };
  };
}
