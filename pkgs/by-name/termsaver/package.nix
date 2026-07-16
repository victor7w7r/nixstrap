{ inputs, python3 }:
python3.pkgs.buildPythonApplication {
  pname = "termsaver";
  version = "latest";
  pyproject = true;
  src = inputs.termsaver;

  nativeBuildInputs = with python3.pkgs; [
    pdm-backend
  ];
  propagatedBuildInputs = with python3.pkgs; [
    pip
  ];
  build-system = with python3.pkgs; [
    hatchling
    setuptools
  ];
  dependencies = with python3.pkgs; [
    pillow
    requests
  ];
}
