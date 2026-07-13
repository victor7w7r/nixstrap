{ appimageTools, inputs }:
appimageTools.wrapType2 {
  pname = "apkstudio";
  version = "latest";
  src = inputs.apkstudio;
  extraPkgs = pkgs: with pkgs; [ apktool ];
}
