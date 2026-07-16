{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "chkufsd";
  version = "latest";
  src = inputs.chkufsd;
  nativeBuildInputs = with pkgs; [ unzip ];
  installPhase = ''mkdir -p $out/bin && install -Dm755 $src/* -t "$out/bin"'';
}
