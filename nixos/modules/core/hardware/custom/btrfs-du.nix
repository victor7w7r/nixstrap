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
    sha256 = "sha256-5A/WDZkWs1fmwQilukYDC9Fug1vG+LPUQWe79ZwSW1M=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/btrfs-du $out/bin/btrfs-du
    chmod +x $out/bin/btrfs-du
  '';

}
