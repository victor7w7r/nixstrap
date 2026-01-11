{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "discli";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/wynwxst/DisCli/releases/download/Discli-1.0/DisCliNux";
    sha256 = "sha256-7QDDO/cP3FOLNMYWrv6Ly5I/m0qABe+lrrpm50kqJP0=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/discli
    chmod +x $out/bin/discli
  '';

}
