{ pkgs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "t2-audio";
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "kekrby";
    repo = "t2-better-audio";
    rev = "e46839a28963e2f7d364020518b9dac98236bcae";
    hash = "sha256-x7K0qa++P1e1vuCGxnsFxL1d9+nwMtZUJ6Kd9e27TFs=";
  };

  dontBuild = true;

  postPatch = ''
    substituteInPlace files/*.rules --replace "/usr/bin/sed" "${pkgs.gnused}/bin/sed"
  '';

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    mkdir -p $out/share/apple-t2-better-audio
    cp files/*.rules $out/lib/udev/rules.d/
    cp -r files $out/share/apple-t2-better-audio/files
  '';
}
