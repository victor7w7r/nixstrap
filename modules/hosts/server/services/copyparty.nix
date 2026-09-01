{ inputs, ... }: {

  flake-file.inputs.copyparty.url = "github:9001/copyparty";

  den.aspects.server.services.copyparty.nixos = { pkgs, ... }: {
    imports = [ inputs.copyparty.nixosModules.default ];
    nixpkgs.overlays = [ inputs.copyparty.overlays.default ];
    environment.systemPackages = [ pkgs.copyparty ];
    services.copyparty.enable = true;
  };
}
