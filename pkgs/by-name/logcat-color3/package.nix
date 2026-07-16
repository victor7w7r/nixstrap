{ inputs, pkgs }:
pkgs.python3.pkgs.buildPythonApplication {
  pname = "logcat-color3";
  version = "1.0";
  pyproject = true;
  src = inputs.logcat-color3;
  build-system = with pkgs.python3.pkgs; [ setuptools-scm ];
  dependencies = with pkgs.python3.pkgs; [
    colorama
    pyasyncore
    pyasynchat
  ];
}
