{ pkgs, ... }:

{
  programs.zen-browser.enable = true;
  home.packages = (
    with pkgs;
    [
      #zen-browser-sponsorblock zen-browser-ublock-origin zen-browser-dark-reader zen-browser-violentmonkey
    ]
  );

}
