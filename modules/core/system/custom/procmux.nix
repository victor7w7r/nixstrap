{ pkgs, fetchurl, ... }:
let
  inherit (pkgs) python3Packages;
  pname = "procmux";
  version = "1.10.0";
in
python3Packages.buildPythonApplication {
  inherit pname version;

  doCheck = false;
  format = "setuptools";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/c1/c8/93ea9e5ffbede1999e96bb7bf6ad7d48870b8438ce55b4f3863ec9688ad8/procmux-2.0.3.tar.gz";
    sha256 = "sha256-u8s1/AVrYR3O3yLUX2Je6in8H3mhukFFNCL35idObdg=";
  };

  propagatedBuildInputs = with python3Packages; [
    setuptools
    requests
  ];
}
