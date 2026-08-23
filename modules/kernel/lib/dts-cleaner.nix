{
  kernel.lib.dts-cleaner =
    {
      pkgs,
      src,
      class,
      dtbMake,
    }:
    pkgs.runCommand "dts-cleaner" { } ''
      mkdir -p $out && cp -r ${src}/* $out/ && chmod -R +w $out
      find "$out/arch/arm64/boot/dts" -mindepth 1 -maxdepth 1 -type d ! -name "${class}" -exec rm -rf {} +
      cat <<EOF > "$out/arch/arm64/boot/dts/Makefile"
        subdir-y += ${class}
      EOF
      cat <<EOF > "$out/arch/arm64/boot/dts/${class}/Makefile"
        ${dtbMake}
      EOF
    '';
}
