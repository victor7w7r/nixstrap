{ inputs, python3 }:
python3.pkgs.buildPythonApplication (attrs: {
  pname = "apkInspector";
  version = "latest";
  pyproject = true;
  src = inputs.apkinspector;
  build-system = with python3.pkgs; [
    hatchling
    setuptools
    poetry-core
  ];
})
