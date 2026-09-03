{ pkgs, stdenvNoCC }:
let
  fetch =
    file: hash:
    pkgs.fetchurl {
      url = "https://github.com/orangepi-xunlong/firmware/raw/master/${file}";
      inherit hash;
    };
in
stdenvNoCC.mkDerivation {
  pname = "uwe5622-firmware";
  version = "latest";
  src = [
    (fetch "wcnmodem.bin" "sha256-EZuHzjCHVzSmdGL3KT+4/oWs8ycP6LeMl4riS+dxWoA=")
    (fetch "wifi_2355b001_1ant.ini" "sha256-HzxA7CRajQuZrRwjcGWX1t1QCKuAzvt7zBlW78TpOPc=")
    (fetch "bt_configure_pskey.ini" "sha256-WnofY/1okWIBAx1LJKEdxnrkX2zWlZULwyX7akh60Kw=")
    (fetch "bt_configure_rf.ini" "sha256-QEQlK679+g6IS2HUxC9NB/dKjzEhuhkj54KWjQE9YX0=")
  ];

  unpackPhase = "true";
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/lib/firmware/
    for s in $src; do
      cp ''$s $out/lib/firmware/''${s/*-/}
    done
  '';
}
