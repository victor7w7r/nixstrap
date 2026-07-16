{ inputs, python3 }:
python3.pkgs.buildPythonApplication {
  pname = "songfetch";
  version = "latest";
  pyproject = true;
  src = inputs.songfetch;
  build-system = with python3.pkgs; [ setuptools ];
  dependencies = with python3.pkgs; [
    ascii-magic
    pillow
  ];
}
