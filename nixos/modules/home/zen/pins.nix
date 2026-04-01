{ ... }:
{
  programs.zen-browser.profiles.default = {
    spacesForce = true;
    pinsForce = true;
    spaces = {
      "Default" = {
        id = "1d674ff6-8b4f-4cfb-9635-c7d569280a0b";
        icon = "";
        position = 0;
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
          opacity = 0.9;
          texture = 0.5;
        };
      };
    };
  };
}
