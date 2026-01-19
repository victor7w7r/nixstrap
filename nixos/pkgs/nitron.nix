{ pkgs, lib, ... }:

let
  nitron = pkgs.stdenv.mkDerivation rec {
    pname = "nitronx";
    version = "1.2";

    src = pkgs.fetchFromGitHub {
      owner = "UsiFX";
      repo = "OpenNitroN";
      rev = "${version}";
      sha256 = "sha256-vF1HKJ5yL5ptBFRbhlKGVgtRDpP1pv9ruUWPu46O00M=";
    };

    installPhase = ''
      mkdir -p $out/usr/bin
      mkdir -p $out/usr/include
      mkdir -p $out/usr/share/man/man1

      install -m 755 nitrond $out/usr/bin/nitrond
      install -m 644 nitronapi.sh $out/usr/include/nitronapi.sh
      install -m 644 nitrond.1 $out/usr/share/man/man1/nitrond.1
    '';

    meta = with lib; {
      description = "Extensive, enhanced Linux kernel tweaker written in Bash";
      homepage = "https://github.com/UsiFX/OpenNitroN";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };
in
{
  environment.systemPackages = [ nitron ];
}
