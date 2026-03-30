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
        "text/html" = "zen.desktop";
        "x-scheme-handler/http" = "zen.desktop";
        "x-scheme-handler/https" = "zen.desktop";
        "x-scheme-handler/about" = "zen.desktop";
        "x-scheme-handler/unknown" = "zen.desktop";
        "application/x-extension-htm" = "zen.desktop";
        "application/x-extension-html" = "zen.desktop";
        "application/x-extension-shtml" = "zen.desktop";
        "application/x-extension-xht" = "zen.desktop";
        "application/x-extension-xhtml" = "zen.desktop";
        "application/xhtml+xml" = "zen.desktop";
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
