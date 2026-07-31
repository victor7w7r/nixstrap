{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "customfetch";
  version = "latest";
  src = inputs.customfetch;
  nativeBuildInputs = with pkgs; [
    gettext
    git
    pkg-config
  ];

  prePatch = "patchShebangs scripts/";

  makeFlags = [
    "DEBUG=0"
    "GUI_APP=0"
    "PREFIX=$(out)"
  ];
}
