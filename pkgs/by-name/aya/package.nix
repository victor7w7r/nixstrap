{ appimageTools, pkgs }:
appimageTools.wrapType2 {
  pname = "aya";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://github.com/liriliri/aya/releases/download/v1.14.2/AYA-1.14.2-linux-x86_64.AppImage";
    sha256 = "sha256-J6wVcyQZGXPBISUMHyu67uj7/2Js/9MJYFobfBwvaWc=";
  };
  extraPkgs = pkgs: with pkgs; [ apktool ];
}
