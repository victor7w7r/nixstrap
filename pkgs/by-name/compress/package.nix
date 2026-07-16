{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "compress";
  version = "latest";
  src = inputs.compress;
  nativeBuildInputs = with pkgs; [ (python3.withPackages (ps: [ ps.pyyaml ])) ];
  installPhase = ''
    mkdir -p $out/bin
    cp $src/src/compress $out/bin
    chmod +x $out/bin/compress
    patchShebangs $out/bin/compress
  '';
}
