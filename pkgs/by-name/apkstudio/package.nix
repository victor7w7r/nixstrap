{ appimageTools, pkgs }:
appimageTools.wrapType2 {
  pname = "apkstudio";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://github.com/vaibhavpandeyvpz/apkstudio/releases/download/v6.3.0/ApkStudio-v6.3.0-x86_64.AppImage";
    sha256 = "sha256-LHzoyxobE4RovY2haQ7COhhCIgXcB6MRuOwWoijvjfY=";
  };
  extraPkgs = pkgs: with pkgs; [ apktool ];
}
