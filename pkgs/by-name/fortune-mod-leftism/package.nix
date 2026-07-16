{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-leftism";
  version = "latest";
  src = inputs.fortune-mod-leftism;
  dontBuild = true;
  nativeBuildInputs = with pkgs; [ fortune ];

  installPhase = ''
    strfile leftist-quotes
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- leftist-quotes leftist-quotes.dat "$out/share/games/fortunes"
  '';
}
