{ inputs, python3 }:
python3.pkgs.buildPythonApplication {
  pname = "procmux";
  version = "latest";
  pyproject = true;
  src = inputs.procmux;

  build-system = with python3.pkgs; [
    hatchling
    setuptools
  ];

  dependencies = with python3.pkgs; [
    hiyapyco
    prompt-toolkit
    #ptterm
    #pyte
    pytest
  ];
}
