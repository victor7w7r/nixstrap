{ appimageTools, inputs }:
appimageTools.wrapType2 {
  pname = "aya";
  version = "latest";
  src = inputs.aya;
  extraPkgs = pkgs: with pkgs; [ apktool ];
}
