{
  host,
  config,
  username,
  ...
}:
{
  home.file = {
    ".xinitrc".text = ''
      export XAUTHORITY=/home/${username}/.Xauthority
      export XDG_SESSION_TYPE=x11
      export DESKTOP_SESSION=xfce
      exec startxfce4
    '';
    "repositories/nixstrap".source = config.lib.file.mkOutOfStoreSymlink "/etc/nixos";
  }
  // (
    if host == "v7w7r-macmini81" then
      {
        "shared".source = config.lib.file.mkOutOfStoreSymlink "/nix/persist/shared";
        "ssdshared".source = config.lib.file.mkOutOfStoreSymlink "/nix/persist/ssdshared";
        "storage".source = config.lib.file.mkOutOfStoreSymlink "/nix/persist/storage";
      }
    else
      { }
  );
  xdg = {
    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "zen-beta.desktop" ];
        "video/png" = [ "vlc.desktop" ];
        "video/jpg" = [ "vlc.desktop" ];
        "video/*" = [ "vlc.desktop" ];
        "x-scheme-handler/http" = [ "zen-beta.desktop" ];
        "x-scheme-handler/chrome" = [ "zen-beta.desktop" ];
        "x-scheme-handler/https" = [ "zen-beta.desktop" ];
        "text/plain" = [ "zed.desktop" ];
        "text/html" = [ "zed.desktop" ];
        "application/x-extension-htm" = [ "zed.desktop" ];
        "application/x-extension-html" = [ "zed.desktop" ];
        "application/x-extension-shtml" = [ "zed.desktop" ];
        "application/xhtml+xml" = [ "zed.desktop" ];
        "application/x-extension-xhtml" = [ "zed.desktop" ];
        "application/x-extension-xht" = [ "zed.desktop" ];
      };
    };
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Escritorio";
      download = "${config.home.homeDirectory}/Descargas";
      documents = "${config.home.homeDirectory}/Documentos";
      pictures = "${config.home.homeDirectory}/Imágenes";
      music = null;
      videos = null;
      templates = null;
      publicShare = null;
    };
  };
}
