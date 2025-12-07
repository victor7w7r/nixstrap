{
  pkgs,
  stdenv,
  fetchFromGitHub,
  ...
}:

let
  nitron = pkgs.stdenv.mkDerivation rec {
    pname = "nitronx";
    version = "1.2.0";

    src = fetchFromGitHub {
      owner = "UsiFX";
      repo = "OpenNitroN";
      rev = "v${version}";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    installPhase = ''
      mkdir -p $out/usr/bin
      mkdir -p $out/usr/include
      mkdir -p $out/usr/share/man/man1

      install -m 755 nitrond $out/usr/bin/nitrond
      install -m 644 nitronapi.sh $out/usr/include/nitronapi.sh
      install -m 644 nitrond.1.gz $out/usr/share/man/man1/nitrond.1.gz
    '';

    meta = {
      description = "Extensive, enhanced Linux kernel tweaker written in Bash";
      homepage = "https://github.com/UsiFX/OpenNitroN";
      license = stdenv.lib.licenses.gpl3;
      platforms = stdenv.lib.platforms.linux;
    };
  };
in
{
  environment.systemPackages = [ nitron ];
}
