{ pkgs, ... }:
{
   programs.zen-browser.profiles.default.extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
      # Check https://nur.nix-community.org/repos/rycee
    adblocker-ultimate
    bitwarden
    catppuccin-web-file-icons
    github-file-icons
    multi-account-containers
    ublock-origin
    youtube-shorts-block
  ];
}
