{ inputs, ... }:
{
  flake-file.inputs.linux-hardened = {
    url = "https://github.com/anthraxx/linux-hardened/releases/download/v7.1.6-hardened1/linux-hardened-v7.1.6-hardened1.patch";
    flake = false;
  };

  kernel.patches.hardened =
    pkgs:
    pkgs.runCommand "hardened-clean.patch" { nativeBuildInputs = [ pkgs.patchutils ]; } ''
      filterdiff -p1 -x "Makefile" -x "a/Makefile" -x "b/Makefile" "${inputs.linux-hardened}" > $out
    '';
}
