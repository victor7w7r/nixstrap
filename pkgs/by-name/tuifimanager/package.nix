{ pkgs, fetchFromGitHub }:
pkgs.python3.pkgs.buildPythonApplication (attrs: {
  pname = "TUIFIManager";
  version = "master";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GiorgosXou";
    repo = attrs.pname;
    rev = attrs.version;
    sha256 = "sha256-KHgHrKL50rdYaHV95z856VOw2vzKqgIgVYDj7WcL67E=";
  };

  propagatedBuildInputs = with pkgs.python3Packages; [
    unicurses
    send2trash
  ];

  build-system = with pkgs.python3.pkgs; [
    hatchling
    setuptools
    setuptools-scm
  ];
})
