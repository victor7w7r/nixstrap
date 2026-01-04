{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "ugm";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/ariasmn/ugm/releases/download/v1.8.0/ugm_1.8.0_linux_amd64";
    sha256 = "sha256-wAvgbRQubjtmxjI4Z6pNy2LDTJXvpSghFBWX/9tjXC4=";
  };

  dontUnpack = true;
  nativeBuildInputs = [ pkgs.autoPatchelfHook ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/ugm
    chmod +x $out/bin/ugm
  '';
}
