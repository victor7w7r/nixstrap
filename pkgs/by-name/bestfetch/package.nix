{ pkgs, stdenv }:
let
  nimYaml = pkgs.fetchFromGitHub {
    owner = "flyx";
    repo = "NimYAML";
    rev = "master";
    sha256 = "sha256-NmsBnwOA3QPK32tP9Vwn/FZ6zAsJ4hzGL2tOMS1pPNI=";
  };
  nimTermstyle = pkgs.fetchFromGitHub {
    owner = "PMunch";
    repo = "termstyle";
    rev = "master";
    sha256 = "sha256-PuvUfjskKI5IA4cAOQ6RugHrVyFit1ihGr4vIDymiLI=";
  };
  nimElvis = pkgs.fetchFromGitHub {
    owner = "mattaylor";
    repo = "elvis";
    rev = "master";
    sha256 = "sha256-KQllIuyEuP4uzKaKBA/2J5/Q3YSaupu7crXV2feXgkA=";
  };
  nimBytesized = pkgs.fetchFromGitLab {
    owner = "Maxb0tbeep";
    repo = "bytesized";
    rev = "main";
    sha256 = "sha256-TH7ZoZozwItGmWpeWNOsoxInpZZI0qT6PkiHaZ/WsI8=";
  };
in
stdenv.mkDerivation (attrs: {
  pname = "bestfetch";
  version = "main";

  src = pkgs.fetchFromGitLab {
    owner = "Maxb0tbeep";
    repo = attrs.pname;
    rev = attrs.version;
    sha256 = "sha256-Voi/HQGFOP14trdAJZ+t0LF8HOSb5+Rbhr4fhvXdGzc=";
  };

  nativeBuildInputs = with pkgs; [ nim-unwrapped ];

  buildInputs = with pkgs; [ openssl ];

  buildPhase = ''
    nim c -d:release \
      --path:${nimTermstyle} \
      --path:${nimTermstyle}/src \
      --path:${nimYaml} \
      --path:${nimYaml}/src \
      --path:${nimElvis} \
      --path:${nimElvis}/src \
      --path:${nimBytesized} \
      --path:${nimBytesized}/src \
      --nimcache:$TMPDIR/nimcache \
      src/${attrs.pname}.nim
  '';

  installPhase = ''
    mkdir -p $out/bin

    if [ -f "src/${attrs.pname}" ]; then
      cp src/${attrs.pname} $out/bin/${attrs.pname}
    else
      cp ${attrs.pname} $out/bin/${attrs.pname}
    fi
  '';
})
