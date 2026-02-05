{ inputs, ... }:
{
  nixpkgs.overlays = [
    (
      pkgs: prev:
      let
        standard = (import ./standard.nix) { inherit pkgs inputs; };
        handheld = (import ./handheld.nix) { inherit pkgs inputs; };
        secured = (import ./secured.nix) { inherit pkgs inputs; };
        server = (import ./server.nix) { inherit pkgs inputs; };
      in
      {
        linux-v7w7r = standard.kernel;
        linuxPackages-v7w7r = standard.packages;
        linux-v7w7r-handheld = handheld.kernel;
        linuxPackages-v7w7r-handheld = handheld.packages;
        linux-v7w7r-hardened = secured.kernel;
        linuxPackages-v7w7r-hardened = secured.packages;
        linux-v7w7r-server = server.kernel;
        linuxPackages-v7w7r-server = server.packages;
      }
    )
  ];
}
