{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "kzones";
  version = "latest";
  src = inputs.kzones;
  nativeBuildInputs = with pkgs; [
    kdePackages.kpackage
    zip
  ];

  buildInputs = with pkgs; [ kdePackages.kwin ];
  dontWrapQtApps = true;
  buildFlags = [ "build" ];
  installPhase = ''
    kpackagetool6 --type=KWin/Script --install=kzones.kwinscript --packageroot=$out/share/kwin/scripts
  '';
}
