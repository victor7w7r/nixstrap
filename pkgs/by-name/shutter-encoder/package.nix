{ pkgs }:
pkgs.appimageTools.wrapType2 {
  pname = "shutter-encoder";
  version = "latest";
  src = pkgs.fetchurl {
    url = "https://www.shutterencoder.com/sdc_download/497/?key=lfpx4wqaghm4zgswrp015tljfm75ek";
    sha256 = "sha256-Wz6hIhTmJt6/ux7s0rck7cKgM1CI3jBXOSogLJqYdWA=";
  };
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
