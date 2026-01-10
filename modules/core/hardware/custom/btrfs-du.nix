{
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:

stdenv.mkDerivation rec {
  pname = "btrfs-du";
  version = "HEAD";
  nativeBuildInputs = [ pkgs.pkg-config ];

  src = fetchFromGitHub {
    owner = "nachoparker";
    repo = pname;
    rev = version;
    sha256 = "sha256-NFBFZ4o5HG5iVFgkH2XOq7pc03vRXbScU2NFQwz3oiA=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/btrfs-du $out/bin/btrfs-du
    chmod +x $out/bin/btrfs-du
  '';

}
