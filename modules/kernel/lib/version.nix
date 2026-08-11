{
  kernel.lib.version =
    pkgs: src: localVer:
    (pkgs.stdenvNoCC.mkDerivation {
      name = "linux-version";
      inherit src;
      installPhase = "cp -r Makefile $out";
      phases = [
        "unpackPhase"
        "installPhase"
      ];
    })
    |> (
      file:
      toString (builtins.match ".+VERSION = ([0-9]+).+" (builtins.readFile file))
      + "."
      + toString (builtins.match ".+PATCHLEVEL = ([0-9]+).+" (builtins.readFile file))
      + "."
      + toString (builtins.match ".+SUBLEVEL = ([0-9]+).+" (builtins.readFile file))
    )
    |> (string: {
      majorMinor = pkgs.lib.versions.majorMinor string;
      final = "${string}-v7w7r-${localVer}";
    });
}
