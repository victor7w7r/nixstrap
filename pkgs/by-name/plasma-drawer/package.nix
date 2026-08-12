{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "plasma-drawer";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://github.com/p-connor/plasma-drawer/releases/download/v2.0.2/plasma-drawer-2.0.2.plasmoid";
    sha256 = "sha256-yPIhR21MM/XHzisJJX6kjE/Vt3EaE5iIlIJliQjOoaE=";
  };
  unpackPhase = ''echo "Skipping unpackPhase"'';
  nativeBuildInputs = with pkgs; [ unzip ];
  propagatedUserEnvPkgs = with pkgs; [ kdePackages.kconfig ];
  dontWrapQtApps = true;
  installPhase = ''
    mkdir tmpdir
    unzip $src -d tmpdir
    mkdir -p $out/share/plasma/plasmoids/p-connor.plasma-drawer
    cp -r tmpdir/* $out/share/plasma/plasmoids/p-connor.plasma-drawer
  '';
}
