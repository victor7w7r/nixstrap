{ pkgs, ... }:
let
  inherit (pkgs) python3Packages;
  pname = "elia-chat";
  version = "1.0.0";
in
python3Packages.buildPythonApplication rec {
  inherit pname version;

  doCheck = false;
  format = "setuptools";
  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";
  };

  propagatedBuildInputs = with python3Packages; [
    setuptools
    requests
  ];
}
