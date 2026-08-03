{ inputs, lib, ... }: {

  kernel.lib.arm-wrapper =
    pkgs: class: dtbMake:
    pkgs.stdenvNoCC.mkDerivation {
      name = "arm-wrapper";
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
      '';
    };
}
