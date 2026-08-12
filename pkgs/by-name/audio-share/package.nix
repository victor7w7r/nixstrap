{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "audio-share";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://github.com/mkckr0/audio-share/releases/download/v0.3.4/audio-share-server-cmd-linux.tar.gz";
    sha256 = "sha256-3PJculwZ8L7YwS7Hw3RSHlx9mL5Q0M6YhiUWELtDUk8=";
  };
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
