{ config, ... }:
{
  xdg.userDirs = {
    desktop = "${config.home.homeDirectory}/tmp";
    download = "${config.home.homeDirectory}/tmp";
    documents = "${config.home.homeDirectory}/files";
    music = "${config.home.homeDirectory}/files/media";
    pictures = "${config.home.homeDirectory}/files/media";
    videos = "${config.home.homeDirectory}/files/media";
  };
}
