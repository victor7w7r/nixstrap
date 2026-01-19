{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "progressline";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/kattouf/ProgressLine/releases/download/0.2.4/progressline-0.2.4-aarch64-unknown-linux-gnu.zip";
    sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/bin/
    chmod +x $out/bin/progressline
  '';
}
