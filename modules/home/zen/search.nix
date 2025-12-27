{ pkgs, ... }:
{
  programs.zen-browser.profiles.default.search = {
    force = true;
    default = "google";
    privateDefault = "google";
    order = [
      "brave"
      "ddg"
      "google"
    ];
    engines =
      let
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      in
      {
        "ddg" = {
          urls = [ { template = "https://duckduckgo.com/?q={searchTerms}"; } ];
          definedAliases = [ "d" ];
        };
        "brave" = {
          urls = [ { template = "https://search.brave.com/search?q={searchTerms}"; } ];
          icon = "https://brave.com/static-assets/images/brave-logo-sans-text.svg";
          definedAliases = [ "br" ];
          updateInterval = 24 * 60 * 60 * 1000;
        };
        "github (code)" = {
          urls = [
            { template = "https://github.com/search?q={searchTerms}&type=code"; }
          ];
          definedAliases = [ "ghc" ];
        };
        "github (repository)" = {
          urls = [
            { template = "https://github.com/search?q={searchTerms}&type=repository"; }
          ];
          definedAliases = [ "ghr" ];
        };
        "home-manager" = {
          urls = [ { template = "https://rycee.gitlab.io/home-manager/options.html"; } ];
          definedAliases = [ "hm" ];
        };
        "nix-packages" = {
          inherit icon;
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [ "np" ];
        };
        "nix-options" = {
          inherit icon;
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [
            "no"
            "nixopts"
          ];
        };
        "proton-db" = {
          urls = [
            {
              template = "https://www.protondb.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          iconMapObj."16" = "https://www.protondb.com/sites/protondb/images/favicon.ico";
          definedAliases = [ "@protondb" ];
        };
        "youtube-music" = {
          urls = [
            {
              template = "https://music.youtube.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          iconMapObj."16" = "https://music.youtube.com/favicon.ico";
          definedAliases = [ "@ytm" ];
        };
        "my-nixos" = {
          inherit icon;
          urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
          definedAliases = [
            "@mn"
            "@nx"
            "@mynixos"
          ];
        };
        "noogle" = {
          inherit icon;
          urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
          updateInterval = 24 * 60 * 60 * 1000;
          definedAliases = [
            "@noogle"
            "@ng"
          ];
        };
        "bing".metaData.hidden = true;
        "google".metaData.alias = "@g";
        "wikipedia".metaData.hidden = true;
      };
  };

}
