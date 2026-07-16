{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "audio-share";
  version = "latest";
  src = inputs.audio-share;
  nativeBuildInputs = with pkgs; [ autoPatchelfHook ];
  buildInputs = with pkgs; [
    pipewire
    stdenv.cc.cc.lib
  ];
  installPhase = ''
    mkdir -p $out/bin
    mv bin/as-cmd $out/bin/audio-share
    chmod +x $out/bin/audio-share
  '';
}
