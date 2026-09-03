{
  den.aspects.gui.obsidian = { user, ... }: {
    nixos = {
      environment.persistence."/nix/persist".users."${user.name}".directories = [
        ".config/obsidian"
      ];
    };

    provides.to-users.homeManager = {

      xdg.desktopEntries.obsidian = {
        name = "Obsidian";
        comment = "Knowledge base";
        icon = "obsidian";
        exec = "obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland";
        mimeType = [ "x-scheme-handler/obsidian" ];
      };

      programs.obsidian = {
        enable = true;
        cli.enable = true;

        defaultSettings = {
          app.alwaysUpdateLinks = true;
          appearance.translucency = false;

          corePlugins = [
            "file-explorer"
            "global-search"
            "switcher"
            "graph"
            "backlink"
            "canvas"
            "outgoing-link"
            "tag-pane"
            "properties"
            "page-preview"
            "daily-notes"
            "templates"
            "note-composer"
            "command-palette"
            "editor-status"
            "bookmarks"
            "outline"
            "word-count"
            "file-recovery"
            "sync"
            "bases"
          ];
        };
      };
    };
  };
}
