{ lib, ... }:
{
  kernel.lib.version = pkgs: src: localVer: rec {
    file = pkgs.stdenvNoCC.mkDerivation {
      name = "calc-version";
      inherit src;
      phases = [
        "unpackPhase"
        "installPhase"
      ];
      installPhase = "cp -r Makefile $out";
    };
    majorMinor = lib.versions.majorMinor string;
    extraversionRaw = builtins.match ".*EXTRAVERSION = ([^\n\r]+).*" (builtins.readFile file);
    extraversion =
      if extraversionRaw != null then lib.strings.trim (builtins.head extraversionRaw) else "";
    string = "${
      toString (builtins.match ".+VERSION = ([0-9]+).+" (builtins.readFile file))
      + "."
      + toString (builtins.match ".+PATCHLEVEL = ([0-9]+).+" (builtins.readFile file))
      + "."
      + toString (builtins.match ".+SUBLEVEL = ([0-9]+).+" (builtins.readFile file))
      + (lib.optionalString (extraversion != "") extraversion)
    }";
    final = "${string}-v7w7r-${localVer}";
  };
}
