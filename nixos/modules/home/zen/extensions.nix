{ pkgs, inputs, ... }:
let
  buildAddon =
    {
      pname,
      version,
      addonId,
      url,
      sha256,
    }:
    pkgs.stdenv.mkDerivation {
      name = "${pname}-${version}";
      src = pkgs.fetchurl { inherit url sha256; };
      preferLocalBuild = true;
      allowSubstitutes = true;
      passthru = { inherit addonId; };
      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    };
in
{
  programs.zen-browser.profiles.default.extensions.packages =
    with inputs.firefox-addons.packages."x86_64-linux";
    [
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
      enhancer-for-youtube
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
      mozilla-addons-to-nix
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
      tampermonkey
      terms-of-service-didnt-read
      themesong-for-youtube-music
      ublock-origin
      video-downloadhelper
      violentmonkey
      wappalyzer
      wikipedia-vector-skin
      youtube-cards
      youtube-nonstop
      youtube-redux
      youtube-shorts-block
      youtube-subscription-groups
      zen-internet
      zoom-redirector
    ]
    ++ [
      #Github Code Folding
      #Github Recommender
      #Github Red Issues
      #Malware Bytes Guard
      (buildAddon (
        let
          version = "1.5";
        in
        {
          pname = "adless_spotify";
          inherit version;
          addonId = "{62e31096-34e6-4503-8806-3d7a6004a1f4}";
          url = "https://addons.mozilla.org/firefox/downloads/file/4098050/adless_spotify-${version}.xpi";
          sha256 = "sha256-U+bQndQkg0NDIfRmSAwu3rbD6Cx+GrC/I43uPs+CMRQ=";
        }
      ))
    ];
}
