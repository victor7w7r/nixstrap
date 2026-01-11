{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "journalview";
  version = "0.0.41";
  src = fetchurl {
    url = "https://github.com/codervijo/journalview/releases/download/v0.0.41/journalview-latest-05.03.2025.zip";
    sha256 = "sha256-D7X5KxFBlE/t0x1HVNheAldBiE0kvN+3mJP7GhEIl0A=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin/
    chmod +x $out/bin/journalview
  '';
}
