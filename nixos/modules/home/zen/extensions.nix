{ inputs, ... }:
{
  programs.zen-browser = {
    profiles.default.extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
      a11ycss
      annotations-restored
      blocktube
      buster-captcha-solver
      catppuccin-web-file-icons
      clearurls
      change-timezone-time-shift
      cliget
      cookie-quick-manager
      copy-as-markdown
      dark-mode-website-switcher
      disconnect
      edit-with-emacs
      enhanced-github
      enhanced-h264ify
      #enhancer-for-youtube
      facebook-container
      foxytab
      github-file-icons
      github-issue-link-status
      google-container
      greasemonkey
      hacktools
      header-editor
      hover-zoom-plus
      image-max-url
      ipvfoo
      istilldontcareaboutcookies
      link-cleaner
      livetl
      lovely-forks
      material-icons-for-github
      multi-account-containers
      musescore-downloader
      no-pdf-download
      octolinker
      octotree
      one-click-wayback
      open-in-browser
      open-in-vlc
      plasma-integration
      protondb-for-steam
      purpleadblock
      refined-github
      return-youtube-dislikes
      ruffle_rs
      search-by-image
      sponsorblock
      #tampermonkey
      terms-of-service-didnt-read
      #themesong-for-youtube-music
      ublock-origin
      #video-downloadhelper
      violentmonkey
      #wappalyzer
      wikipedia-vector-skin
      #youtube-cards
      youtube-nonstop
      youtube-redux
      youtube-shorts-block
      youtube-subscription-groups
      zen-internet
      zoom-redirector
    ];
    policies.ExtensionSettings =
      let
        mkExtensionSettings = builtins.mapAttrs (
          _: pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
            installation_mode = "force_installed";
          }
        );
      in
      (mkExtensionSettings {
        "{62e31096-34e6-4503-8806-3d7a6004a1f4}" = "adless_spotify";
        "{b588f8ac-dbdf-4397-bcd7-3d29be2f17d7}" = "github_code_folding";
        "{70e5b770-918b-4d4d-a41e-7206016fe206}" = "github_recommender";
        "{3e7882e9-4411-4136-9c76-8fddc57c8d87}" = "github_red_issues";
        "{242af0bb-db11-4734-b7a0-61cb8a9b20fb}" = "malwarebytes";
      });
  };
}
