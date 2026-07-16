{ inputs, pkgs }:
pkgs.appimageTools.wrapType2 {
  pname = "shutter-encoder";
  version = "latest";
  src = inputs.shutter-encoder;
  extraPkgs =
    pkgs: with pkgs; [
      ffmpeg
      mediainfo
      dvdauthor
      yt-dlp
      exiftool
      p7zip
      realesrgan-ncnn-vulkan
      alsa-lib
      gtk3
      glib
    ];
}
