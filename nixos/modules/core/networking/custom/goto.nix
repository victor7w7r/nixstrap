{
  pkgs,
  stdenv,
  fetchurl,
  ...
}:
stdenv.mkDerivation {
  pname = "goto";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/grafviktor/goto/releases/download/v1.5.0/goto-v1.5.0.zip";
    sha256 = "sha256-iBAgKYhu6v82+2DdINdVsAFWQRw6zQZWgA1FlzNKkwk=";
  };

  nativeBuildInputs = with pkgs; [ unzip ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    unzip $src -d $out/
    mv $out/goto-v1.5.0/gg-lin $out/bin/
    chmod +x $out/bin/gg-lin
  '';

}
