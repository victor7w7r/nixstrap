{
  pkgs,
  inputs,
  host,
  ...
}:
let
  zen-unwrap =
    (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.beta-unwrapped.override {
      policies = (import ./policies.nix);
    }).overrideAttrs
      (prev: {
        postInstall = prev.postInstall or "" + ''
          chmod -R u+w "$out/lib/zen-bin-${prev.version}"
          cp -r "${inputs.sine-bootloader}/program/"* \
            "$out/lib/zen-bin-${prev.version}"
        '';
      });
in
{
  programs.zen-browser = {
    package = (pkgs.wrapFirefox zen-unwrap { icon = "zen-browser"; }).override {
      nativeMessagingHosts = [ pkgs.pywalfox-native ];
    };
    enable = host != "v7w7r-youyeetoox1";
    setAsDefaultBrowser = true;
    nixGL.enable = true;
    languagePacks = [ "es-ES" ];
    profiles.default = {
      id = 0;
      isDefault = true;
      name = "default";
      pinsForce = true;
      spaces."Default" = {
        id = "1d674ff6-8b4f-4cfb-9635-c7d569280a0b";
        icon = "";
        position = 0;
        theme = {
          opacity = 0.9;
          texture = 0.5;
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
    ./bookmarks.nix
    ./extensions.nix
    ./mods.nix
    ./search.nix
    ./settings.nix
  ];
}
