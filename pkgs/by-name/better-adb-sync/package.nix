{ inputs, python3 }:
python3.pkgs.buildPythonApplication {
  pname = "better-adb-sync";
  version = "latest";
  pyproject = true;
  src = inputs.better-adb-sync;
  build-system = with python3.pkgs; [ setuptools ];
}
