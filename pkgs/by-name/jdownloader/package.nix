{
  lib,
  pkgs,
  inputs,
}:
let
  icon = pkgs.fetchurl {
    url = "https://jdownloader.org/_media/vote/trazo.png";
    sha256 = "3ebab992e7dd04ffcb6c30fee1a7e2b43f3537cb2b22124b30325d25bffdac29";
  };

  wrapper = pkgs.writeScript "jdownloader" ''
    #! ${pkgs.stdenvNoCC.shell}
    PATH=${
      lib.makeBinPath [
        pkgs.jre
        pkgs.coreutils
      ]
    }
    JDJAR=''${XDG_DATA_HOME:-$HOME/.local/share}/jdownloader/JDownloader.jar
    if [ ! -f ''${JDJAR} ]; then
        install -Dm755 ${inputs.jdownloader} ''${JDJAR}
    fi
    ${pkgs.jre}/bin/java -jar ''${JDJAR} "''${@}"
  '';
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "jdownloader2";
  version = "2.0";
  src = inputs.jdownloader;
  dontUnpack = true;
  nativeBuildInputs = with pkgs; [
    jre
    graphicsmagick
    copyDesktopItems
  ];

  desktopItems = [
    (pkgs.makeDesktopItem {
      name = "JDownloader 2";
      exec = wrapper;
      icon = "jdownloader";
      comment = "Free, open-source download management tool.";
      desktopName = "JDownloader 2";
      genericName = "JDownloader 2";
      categories = [ "Network" ];
    })
  ];

  installPhase = ''
    mkdir -pv $out/bin $out/share/applications
    cp ${inputs.jdownloader} $out/bin/JDownloader.jar

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      gm convert -resize "$size"x"$size" ${icon} $out/share/icons/hicolor/"$size"x"$size"/apps/jdownloader.png
    done

    copyDesktopItems
  '';
}
