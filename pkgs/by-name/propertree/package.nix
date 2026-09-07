{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "propertree";
  version = "0-unstable-2026-06-20";

  src = pkgs.fetchFromGitHub {
    owner = "corpnewt";
    repo = "ProperTree";
    rev = "51ed53dbe3c96a81686ae1fc47f6d2a92f668159";
    hash = "sha256-yDkIALfDh8LcCStZGPaUDQbmDdei6nir8XSed2ZqOIs=";
  };

  buildInputs = [
    (pkgs.python3.withPackages (ps: with ps; [ tkinter ]))
    pkgs.copyDesktopItems
    pkgs.makeWrapper
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "propertree";
      exec = "propertree";
      desktopName = "ProperTree";
      categories = [ "Utility" ];
    })
  ];

  buildPhase = ''
    mkdir -p $out/libexec $out/bin
    cp -r $src $out/libexec/propertree
    patchShebangs
    makeWrapper $out/libexec/propertree/ProperTree.py $out/bin/propertree
  '';

  passthru.updateScript = pkgs.nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };
}
