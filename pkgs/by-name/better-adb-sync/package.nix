{ inputs, python3 }:
python3.pkgs.buildPythonApplication {
  pname = "better-adb-sync";
  version = "latest";
  pyproject = true;
  src = inputs.better-adb-sync;
  dontCheckRuntimeDeps = true;
  build-system = with python3.pkgs; [
    hatchling
    setuptools
  ];
}
