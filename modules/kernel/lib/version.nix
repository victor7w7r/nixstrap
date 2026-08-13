{
  kernel.lib.version =
    pkgs: src: localVer:
    (pkgs.runCommand "sunxi-patches" { } "cp ${src}/Makefile $out")
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
