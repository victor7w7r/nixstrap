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
        nativeBuildInputs = with pkgs; [
          dtc
          buildPackages.stdenv.cc
        ];
      }
      ''
        mkdir -p src build && cp -r ${src}/* src/ && chmod -R +w src
        find "src/arch/arm64/boot/dts" -mindepth 1 -maxdepth 1 -type d ! -name "${class}" -exec rm -rf {} +
        find "src/arch/arm64/boot/dts/${class}" -maxdepth 1 -type f ! -name '${dtbClass}*' -delete

        mkdir -p "src/arch/arm64/boot/dts/${class}/overlay"
        cp -r ${overlays}/* src/arch/arm64/boot/dts/${class}/overlay/ && chmod -R +w src
        find src/arch/arm64/boot/dts/${class}/overlay -maxdepth 1 -type f ! -name '${overlayClass}-*' -delete

        for f in src/arch/arm64/boot/dts/${class}/overlay/*.dts src/arch/arm64/boot/dts/${class}/overlay/*.dtso; do
          if [ -f "$f" ]; then
            base=$(basename "$f")

            dts_preprocessed=$(cpp -nostdinc \
              -I src/include \
              -I src/arch/arm64/boot/dts \
              -I src/arch/arm64/boot/dts/${class} \
              -I src/arch/arm64/boot/dts/${class}/overlay \
              -undef -D__DTS__ -x assembler-with-cpp "$f")

            if echo "$dts_preprocessed" | grep -q "/plugin/;"; then
              name=$(echo "$base" | sed -E 's/\.(dtso|dts)$/\.dtbo/')
              echo "Compiling OVERLAY: $f -> build/$name"
              echo "$dts_preprocessed" | dtc -@ -I dts -O dtb -o "build/$name" - || true
            else
              name=$(echo "$base" | sed -E 's/\.(dtso|dts)$/\.dtb/')
              echo "Compiling BASE DTB: $f -> build/$name"

              echo "$dts_preprocessed" | dtc -I dts -O dtb -o "build/$name" - || true
            fi
          fi
        done

        mkdir -p $out && mv build/* $out/
      '';
}
