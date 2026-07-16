{ inputs, pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "ffmpeg-audio-thumbnailer";
  version = "latest";
  src = inputs.ffmpeg-audio-thumbnailer;
  buildInputs = with pkgs; [ ffmpeg ];
  makeFlags = [ "PREFIX=$(out)" ];
}
