{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "sha256-animation";
  version = "latest";
  src = inputs.sha256-animation;
  buildInputs = with pkgs; [ ruby ];
  propagatedBuildInputs = with pkgs; [ ruby ];
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    for file in add blocks ch compression constants sha256 shr rotr sigma0 sigma1 usigma0 usigma1 ch maj; do
      cp $file.rb $out/bin/$file
      chmod +x $out/bin/$file
      sed -i '1i #!/usr/bin/env ruby' $out/bin/$file
    done
    patchShebangs $out/bin
  '';
}
