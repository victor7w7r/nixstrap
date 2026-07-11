{ pkgs, stdenvNoCC }:
stdenvNoCC.mkDerivation (attrs: {
  pname = "memavaild";
  version = "v0.5-de0870e";

  src = pkgs.fetchFromGitHub {
    owner = "hakavlad";
    repo = attrs.pname;
    rev = "55352fe";
    sha256 = "sha256-qzEQ8iT4TlOeXv0ihyr7Z+oKfsGXIlkKOURkp9PoYFM=";
  };

  propagatedBuildInputs = with pkgs; [ python3 ];

  installPhase = ''
    PREFIX= DESTDIR=$out SYSTEMDUNITDIR=/lib/systemd/system SYSCONFDIR=/etc make base units
    substituteInPlace $out/lib/systemd/system/memavaild.service \
      --replace "ExecStart=" "ExecStart=$out"
  '';
})
