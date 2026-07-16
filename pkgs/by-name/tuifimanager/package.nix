{ inputs, pkgs }:
pkgs.python3.pkgs.buildPythonApplication {
  pname = "TUIFIManager";
  version = "latest";
  pyproject = true;
  src = inputs.tuifimanager;
  propagatedBuildInputs = with pkgs.python3Packages; [
    unicurses
    send2trash
  ];
  build-system = with pkgs.python3.pkgs; [ setuptools-scm ];
}
