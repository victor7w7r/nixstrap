{
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation rec {
  pname = "AeroFetch";
  version = "HEAD";
  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = "driizzyy";
    repo = pname;
    rev = version;
    sha256 = "sha256-QXNkKGSolReq6F0PnNfBHj2RbwC6+8qgNUD4rJZXWBU=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 $src/AeroFetch.sh $out/bin/aerofetch
    runHook postInstall
  '';

}
