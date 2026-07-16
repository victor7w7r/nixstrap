{ inputs, pkgs }:
pkgs.python3.pkgs.buildPythonApplication {
  pname = "tewi";
  version = "latest";
  pyproject = true;
  src = inputs.tewi;
  build-system = with pkgs.python3.pkgs; [
    hatchling
    setuptools
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    textual
    transmission-rpc
    pyperclip
    qbittorrent-api
    platformdirs
    (pkgs.python3Packages.buildPythonPackage rec {
      pname = "geoip2fast";
      version = "1.2.2";
      pyproject = true;
      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-OIFXAM7f6xl9UbS4czsNT3lls23hUUfBJVJxJPi0XWs=";
      };
      nativeBuildInputs = with pkgs.python3Packages; [
        setuptools
        wheel
      ];
      doCheck = false;
    })
  ];
}
