{ inputs, pkgs }:
pkgs.python3.pkgs.buildPythonApplication {
  pname = "rofi-tmux";
  version = "latest";
  format = "setuptools";
  src = inputs.rofi-tmux;
  propagatedBuildInputs = with pkgs.python3.pkgs; [
    click
    i3ipc
    libtmux
  ];
}
