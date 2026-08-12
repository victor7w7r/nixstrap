{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "chkufsd";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://archive.org/download/tools_202401/tools.zip";
    sha256 = "sha256-lINfV2LeKf68voizc16v4XrbGZe2tIT2s5x6FEdqk2w=";
  };
  nativeBuildInputs = with pkgs; [ unzip ];
  installPhase = ''mkdir -p $out/bin && install -Dm755 $src/* -t "$out/bin"'';
}
