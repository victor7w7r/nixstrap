{
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "cargofetch";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/arjav0703/cargofetch/releases/download/v1.30/cargofetch";
    sha256 = "sha256-VpWcfwDHvkIgxEQGgj3gTejneZlfxY48wAFwzBdPUdc=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/cargofetch
    chmod +x $out/bin/cargofetch
  '';
}
