{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "plasma-drawer";
  version = "latest";
  src = inputs.plasma-drawer;
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
