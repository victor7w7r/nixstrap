{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "ytdl";
  version = "latest";
  src = inputs.ytdl;
  installPhase = ''
    mkdir -p $out/bin
    cp $src/ytdl.sh $out/bin/ytdl
    chmod +x $out/bin/ytdl
  '';
}
