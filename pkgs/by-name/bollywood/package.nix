{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "bollywood";
  version = "latest";
  src = inputs.bollywood;
  nativeBuildInputs = [ pkgs.makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp $src/config.kdl $out/lib/
    cp $src/layout.kdl $out/lib/
    sed -i "s|command=\"./stam.sh\"|command=\"${placeholder "out"}/bin/stam.sh\"|g" $out/lib/layout.kdl

    cp ${pkgs.writeShellScriptBin "ascii-crazy" ''
      while [[ 1 ]]; do
        curl -s "https://asciinema.org/search?q=$((RANDOM % 100))&page=$((1 + RANDOM % 10))" \
          | grep 'thumbnail-link' | cut -d '"' -f 2 \
          | xargs -n 1 printf "asciinema play -s 15 https://asciinema.org/%s\n" \
          | bash
      done
    ''}/bin/ascii-crazy $out/bin/stam.sh

    wrapProgram $out/bin/stam.sh \
      --prefix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.curl
          pkgs.gnugrep
          pkgs.coreutils
          pkgs.findutils
          pkgs.asciinema
          pkgs.bash
        ]
      }

    echo "#!${pkgs.runtimeShell}" > $out/bin/bollywood
    echo "${pkgs.zellij}/bin/zellij -l $out/lib/layout.kdl --config $out/lib/config.kdl" >> $out/bin/bollywood
    chmod +x $out/bin/bollywood
    chmod +x $out/bin/stam.sh
  '';
}
