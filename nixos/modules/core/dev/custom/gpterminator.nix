{ pkgs, fetchurl, ... }:
let
  inherit (pkgs) python3Packages;
  pname = "gpterminator";
  version = "1.0.0";
in
python3Packages.buildPythonApplication {
  inherit pname version;

  doCheck = false;
  format = "setuptools";
  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/3b/08/8b77b43c4fc6da2ad3aab16a3f22c1bdd28bdf9fdd2b9d01dbd99f8c23bf/gpterminator-0.1.11.tar.gz";
    sha256 = "sha256-2gvm0hOLYgmONH/QnG8xDTveh3RXp3dP5ganxBNaOA4=";
  };

  propagatedBuildInputs = with python3Packages; [
    setuptoolskB
    requests
  ];

}
