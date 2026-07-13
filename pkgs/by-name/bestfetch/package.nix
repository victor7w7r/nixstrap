{ pkgs, inputs }:
let
  nimYaml = inputs.nimYaml;
  nimTermstyle = inputs.nimTermstyle;
  nimElvis = inputs.nimElvis;
  nimBytesized = inputs.nimBytesized;
in
pkgs.stdenv.mkDerivation (attrs: {
  pname = "bestfetch";
  version = "latest";
  src = inputs.bestfetch;
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
