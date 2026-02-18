{ ... }:
{
  programs.zen-browser.profiles.default = {
    spacesForce = true;
    pinsForce = true;
    pins = {
      "GitHub" = {
        id = "48e8a119-5a14-4826-9545-91c8e8dd3bf6";
        url = "https://github.com";
        position = 101;
        isEssential = true;
      };
    };
    spaces = {
      "DefaultSpace" = {
        id = "1d674ff6-8b4f-4cfb-9635-c7d569280a0b";
        icon = "";
        position = 1000;
      };
    };
  };
}
