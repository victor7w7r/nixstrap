{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "hexfetch";
  version = "latest";
  src = inputs.hexfetch;
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  buildInputs = with pkgs; [
    lsb-release
    figlet
  ];

  buildPhase = "cd src && gcc hexfetch.c -o hexfetch";
  installPhase = ''
    mkdir -p $out/bin
    cp hexfetch $out/bin/
    wrapProgram $out/bin/hexfetch \
      --prefix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.lsb-release
          pkgs.figlet
        ]
      }
  '';
}
