{ appimageTools, inputs }:
appimageTools.wrapType2 {
  pname = "aya";
  version = "1.14.2";
  src = inputs.aya;
  extraPkgs = pkgs: with pkgs; [ apktool ];
}
