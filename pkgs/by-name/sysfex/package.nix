{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "sysfex";
  version = "latest";
  src = inputs.sysfex;
  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    makeWrapper
  ];
  buildInputs = with pkgs; [ icu ];
  installPhase = ''
    mkdir -p $out/bin
    if [ -f "sysfex" ]; then
      cp sysfex $out/bin/
    else
      cp bin/sysfex $out/bin/ || find . -name sysfex -exec cp {} $out/bin/ \;
    fi

    wrapProgram $out/bin/sysfex \
      --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.pciutils ]}
  '';
}
