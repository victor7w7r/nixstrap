{
  config,
  pkgs,
  inputs,
  host,
  ...
}:
let
  package = (pkgs.callPackage ./package.nix { inherit inputs; });
  zenDir = config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/zen";
in
{
  home.file.".zen".source = zenDir;
  xdg.configFile = {
    ".zen".source = zenDir;
    /*
      "zen/default/chrome" = {
      source = package.chrome;
      recursive = true;
      };
    */
  };

  programs.zen-browser = {
    package = package.zen-wrap;
    enable = host != "v7w7r-youyeetoox1";
    setAsDefaultBrowser = true;
    languagePacks = [ "es-ES" ];
    profiles.default = {
      id = 0;
      isDefault = true;
      name = "default";
      pinsForce = true;
      bookmarks.force = true;
      spaces."Default" = {
        id = "1d674ff6-8b4f-4cfb-9635-c7d569280a0b";
        icon = "";
        position = 0;
        opacity = 0.9;
        texture = 0.5;
        theme = {
          colors = [
            {
              red = 63;
              green = 3;
              blue = 10;
              algorithm = "floating";
              type = "explicit-lightness";
            }
          ];
        };
      };
    };
  };

  imports = [
    (import ./bookmarks.nix)
    (import ./extensions.nix)
    (import ./mods.nix)
    (import ./pins.nix)
    (import ./settings.nix)
    (import ./search.nix)
  ];

}
