{ inputs, pkgs }:
pkgs.stdenv.mkDerivation (attrs: {
  pname = "fortune-mod-archlinux";
  version = "latest";
  src = inputs.fortune-mod-archlinux;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src archlinux
    strfile archlinux
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- archlinux archlinux.dat "$out/share/games/fortunes"
  '';
})
