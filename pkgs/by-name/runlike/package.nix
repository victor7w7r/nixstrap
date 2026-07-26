{ inputs, python3 }:
python3.pkgs.buildPythonApplication {
  pname = "runlike";
  version = "latest";
  pyproject = true;
  src = inputs.runlike;
  build-system = with python3.pkgs; [ poetry-core ];
}
