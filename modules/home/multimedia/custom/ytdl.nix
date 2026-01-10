{
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  pname = "ytdl";
  version = "HEAD";
  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = "codewithmoss";
    repo = pname;
    rev = version;
    sha256 = "sha256-NFBFZ4o5HG5iVFgkH2XOq7pc03vRXbScU2NFQwz3oiA=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/ytdl.sh $out/bin/ytdl
    chmod +x $out/bin/ytdl
  '';

}
