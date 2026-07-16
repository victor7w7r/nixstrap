{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-vimtips";
  version = "latest";
  src = inputs.fortune-mod-vimtips;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src vimtips
    strfile vimtips
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- vimtips vimtips.dat "$out/share/games/fortunes"
  '';
}
