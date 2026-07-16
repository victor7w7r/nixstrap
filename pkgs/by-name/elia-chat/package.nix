{ inputs, python3 }:
python3.pkgs.buildPythonApplication (attrs: {
  pname = "elia";
  version = "main";
  pyproject = true;
  src = inputs.elia-chat;

  dontCheckRuntimeDeps = true;
  build-system = with python3.pkgs; [
    hatchling
    setuptools
  ];
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "textual==0.79.1" "textual"
  '';

  dependencies = with python3.pkgs; [
    aiosqlite
    click
    click-default-group
    humanize
    google-generativeai
    greenlet
    litellm
    networkx
    pyperclip
    sqlmodel
    textual
    tree-sitter
    xdg-base-dirs
  ];
})
