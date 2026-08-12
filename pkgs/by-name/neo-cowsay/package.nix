{ pkgs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "neo-cowsay";
  version = "latest";
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin $out/cowsay
    cp -r ${
      if pkgs.stdenvNoCC.hostPlatform.isAarch64 then
        pkgs.fetchurl {
          url = "https://github.com/Code-Hex/Neo-cowsay/releases/download/v2.0.4/cowsay_2.0.4_Linux_arm64.tar.gz";
          sha256 = "sha256-Mccde2h67SmrS7vKk29wDUwkWr/fVzvAFm5g31yYQ1A=";
        }
      else
        pkgs.fetchurl {
          url = "https://github.com/Code-Hex/Neo-cowsay/releases/download/v2.0.4/cowsay_2.0.4_Linux_x86_64.tar.gz";
          sha256 = "sha256-31LmLOPBOYcf+NKr3qxUhKCshJidJiWib/pgH2Rw5QA=";
        }
    }/* $out/cowsay/
    mv $out/cowsay/cowsay $out/bin/ && mv $out/cowsay/cowthink $out/bin/
    chmod +x $out/bin/cowsay && chmod +x $out/bin/cowthink
  '';
}
