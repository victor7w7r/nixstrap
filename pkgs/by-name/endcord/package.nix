{ inputs, pkgs }:
pkgs.python3.pkgs.buildPythonApplication {
  pname = "endcord";
  version = "latest";
  pyproject = true;
  src = inputs.endcord;

  build-system = with pkgs.python3.pkgs; [
    setuptools
    cython
  ];

  propagatedBuildInputs = with pkgs.python3Packages; [
    filetype
    numpy
    orjson
    pycryptodome
    python-socks
    soundcard
    soundfile
    websocket-client
  ];

  postPatch = ''
    if [ -f pyproject.toml ]; then
      substituteInPlace pyproject.toml \
        --replace "numpy>=2.4.6" "numpy>=2.4.4" \
        --replace "orjson>=3.11.9" "orjson>=3.11.7" \
        --replace "soundfile>=0.14.0" "soundfile>=0.13.1"
    fi
  '';
}
