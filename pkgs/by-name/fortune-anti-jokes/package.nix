{ inputs, pkgs }:
pkgs.stdenv.mkDerivation (attrs: {
  pname = "fortune-anti-jokes";
  version = "latest";
  src = inputs.fortune-anti-jokes;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    strfile -r anti-jokes
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- anti-jokes anti-jokes.dat "$out/share/games/fortunes"
  '';
})
