{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      easyeffects
      # easyeffects-bundy01-presets easyeffects-jtrv-presets-git
      lsp-plugins
      calf
      zam-plugins
      mda-lv2
    ]
  );

}
