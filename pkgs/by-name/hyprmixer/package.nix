{ inputs, pkgs }:
pkgs.appimageTools.wrapType2 {
  pname = "hyprmixer";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://github.com/Torelli/hyprmixer/releases/download/1.0.1/hyprmixer.AppImage";
    sha256 = "sha256-sOB9LAbr6lCV7iwf7nIqxY9rEhyWABVEuiSuyHBbEcg=";
  };
  extraPkgs = pkgs: with pkgs; [ rofi ];
}
