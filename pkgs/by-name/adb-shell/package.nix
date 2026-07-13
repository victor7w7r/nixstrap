{ pkgs, inputs }:
pkgs.python3.pkgs.buildPythonApplication (attrs: {
  pname = "adb_shell";
  version = "master";
  format = "setuptools";

  src = builtins.trace inputs (
    pkgs.fetchFromGitHub {
      owner = "JeffLIrion";
      repo = attrs.pname;
      rev = attrs.version;
      sha256 = "sha256-8Vqd3N87WyfvE2qt+CLaKIYj/rWGNAObaI8LOzV3yAk=";
    }
  );
})
