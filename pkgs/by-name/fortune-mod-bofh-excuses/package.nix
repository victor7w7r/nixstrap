{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "fortune-mod-bofh-excuses";
  version = "latest";
  src = inputs.fortune-mod-bofh-excuses;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [ fortune ];
  installPhase = ''
    cp $src bofh-excuses.raw
    ${pkgs.gawk}/bin/awk '{ printf "BOFH excuse #%d:\n\n%s\n%%\n", FNR, $0 }' \
      bofh-excuses.raw > bofh-excuses
    strfile bofh-excuses
    install -dm755 -- "$out/share/games/fortunes"
    install -m644 -- bofh-excuses bofh-excuses.dat "$out/share/games/fortunes"
  '';
}
