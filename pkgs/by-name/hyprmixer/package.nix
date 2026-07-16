{ inputs, pkgs }:
pkgs.appimageTools.wrapType2 {
  pname = "hyprmixer";
  version = "latest";
  src = inputs.hyprmixer;
  extraPkgs = pkgs: with pkgs; [ rofi ];
}
