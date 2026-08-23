{ lib, ... }: {
  kernel.lib.dts-compiler =
    {
      pkgs,
      src,
      class,
      dtbClass,
      overlays,
      overlayClass,
      extraClass ? null,
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

        ${lib.optionalString (extraClass != null) ''
          find src/arch/arm64/boot/dts/${class}/overlay -maxdepth 1 -type f \
            \( ${lib.concatMapStringsSep " -o " (c: "-name '*${c}*'") extraClass} \) \
            -delete
        ''}

        for f in src/arch/arm64/boot/dts/${class}/overlay/*.dts src/arch/arm64/boot/dts/${class}/overlay/*.dtso; do
          if [ -f "$f" ]; then
            base=$(basename "$f")

            echo "Processing $base..."

            cpp -nostdinc \
              -I src/arch/arm64/boot/dts \
              -I src/arch/arm64/boot/dts/${class} \
              -I src/arch/arm64/boot/dts/${class}/overlay \
              -I src/include \
              -I src/scripts/dtc/include-prefixes \
              -undef -D__DTS__ -D__KERNEL__ -x assembler-with-cpp "$f" > preprocessed.tmp 2>/dev/null || true

            if [ -s preprocessed.tmp ]; then
              if grep -q "/plugin/;" preprocessed.tmp; then
                name=$(echo "$base" | sed -E 's/\.(dtso|dts)$/\.dtbo/')
                echo " -> Compiling OVERLAY: build/$name"
                dtc -@ -I dts -O dtb -o "build/$name" preprocessed.tmp || true
              else
                name=$(echo "$base" | sed -E 's/\.(dtso|dts)$/\.dtb/')
                echo " -> Compiling BASE DTB: build/$name"
                dtc -I dts -O dtb -o "build/$name" preprocessed.tmp || true
              fi
            else
              echo "  ERROR for $f"
            fi
            rm -f preprocessed.tmp
          fi
        done

        mkdir -p $out && mv build/* $out/
      '';
}
