{ inputs, lib, ... }: {

  kernel.lib.linux-wrapper =
    {
      pkgs,
      class ? "",
      dtbMake ? "",
      extra ? "",
    }:
    pkgs.stdenvNoCC.mkDerivation {
      name = "linux-wrapper";
      src = inputs.linux;
      dontBuild = true;
      dontConfigure = true;
      installPhase = "mkdir -p $out && cp -r . $out/";

      postPatch = ''
        ${lib.optionalString (class != "") ''
          find "./arch/arm64/boot/dts" -mindepth 1 -maxdepth 1 -type d ! -name "${class}" -exec rm -rf {} +
          cat <<EOF > "./arch/arm64/boot/dts/Makefile"
              subdir-y += ${class}
          EOF
          cat <<EOF > "./arch/arm64/boot/dts/${class}/Makefile"
              ${dtbMake}
          EOF
        ''}
        ${extra}
      '';
    };
}
