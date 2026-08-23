{
  kernel.lib.dts-compiler =
    {
      pkgs,
      src,
      class,
      dtbClass,
      overlays ? null,
      overlayClass ? null,
    }:
    pkgs.runCommand "dts-compiler"
      {
        nativeBuildInputs = with pkgs; [ dtc ];
      }
      ''
        mkdir -p src build && cp -r ${src}/* src/ && chmod -R +w src
        find "src/arch/arm64/boot/dts" -mindepth 1 -maxdepth 1 -type d ! -name "${class}" -exec rm -rf {} +
        find "src/arch/arm64/boot/dts/${class}" -maxdepth 1 -type f ! -name '${dtbClass}*' -delete

        mkdir -p "src/arch/arm64/boot/dts/${class}/overlay"
        cp -r ${overlays}/* src/arch/arm64/boot/dts/${class}/overlay/ && chmod -R +w src
        find src/arch/arm64/boot/dts/${class}/overlay -maxdepth 1 -type f ! -name '${overlayClass}-*' -delete

        for f in src/arch/arm64/boot/dts/${class}/*.dts src/arch/arm64/boot/dts/${class}/overlay/*.dtso; do
          if [ -f "$f" ]; then
            base=$(basename "$f")
            name=$(echo "$base" | sed -E 's/\.(dtso|dts)$/\.dtbo/')
            echo "Compiling: $f -> build/$name"
            dtc -@ -I dts -O dtb -o "build/$name" "$f" || true
          fi
        done

        mkdir -p $out && mv build/* $out/
      '';
}
