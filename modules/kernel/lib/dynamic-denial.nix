{ lib, ... }:
{
  kernel.lib.dynamic-denial =
    {
      config,
      attr,
      excludes ? [ ],
    }:
    config
    |> builtins.readFile
    |> lib.strings.splitString "\n"
    |> builtins.filter (
      line: (lib.hasPrefix "CONFIG_${attr}_" line) || (lib.hasInfix "CONFIG_${attr}_" line)
    )
    |> builtins.concatMap (
      line:
      let
        match = builtins.match ".*CONFIG_(${attr}_[A-Za-z0-9_]+).*" line;
        name = if match != null then builtins.elemAt match 0 else null;
        isExcluded =
          if name != null then builtins.any (ex: lib.strings.hasInfix ex name) excludes else false;
      in
      lib.optional (match != null && !isExcluded) {
        inherit name;
        value = "n";
      }
    )
    |> builtins.listToAttrs;
}
