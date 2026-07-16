{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "appimage-thumbnailer";
  version = "latest";
  src = inputs.appimage-thumbnailer;
  buildInputs = with pkgs; [
    bash
    imagemagick
  ];
  installPhase = ''
    mkdir -p $out/bin $out/share/thumbnailers
    mv AppImage-thumbnailer "$out/bin/"
    mv AppImage-thumbnailer.thumbnailer "$out/share/thumbnailers/"
    chmod +x $out/bin/AppImage-thumbnailer
  '';
}
