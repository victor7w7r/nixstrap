{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation (attrs: {
  pname = "jar-thumbnailer";
  version = "main";
  src = inputs.jar-thumbnailer;
  buildInputs = with pkgs; [
    coreutils
    bash
    gnused
    unzip
  ];
  installPhase = ''
    mkdir -p $out/bin $out/share/thumbnailers
    mv jar-thumbnailer "$out/bin/"
    mv jar.thumbnailer "$out/share/thumbnailers/"
    chmod +x $out/bin/jar-thumbnailer
  '';
})
