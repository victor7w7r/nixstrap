{ python3, inputs }:
python3.pkgs.buildPythonApplication {
  pname = "adb_shell";
  version = "latest";
  format = "setuptools";
  src = inputs.adb_shell;
}
