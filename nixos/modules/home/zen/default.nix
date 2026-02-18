{
  config,
  inputs,
  pkgs,
  system,
  ...
}:
{
  imports = [
    (import ./bookmarks.nix)
    (import ./extensions.nix)
    (import ./pins.nix)
    (import ./settings.nix)
    (import ./search.nix)
  ];

  programs.zen-browser = {
    enable = true;
    /*
      package = (
      config.lib.nixGL.wrap (
        (pkgs.wrapFirefox) (inputs.zen-browser.packages.${system}.twilight-unwrapped.override {
          policies = import ./policies.nix;
        }) { }
      )
      );
    */
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
    languagePacks = [ "es-ES" ];
    profiles.default = {
      id = 0;
      isDefault = true;
      name = "default";
      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
      extraConfig = ''
        ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
        ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
        ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
        ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
      '';
      sine = {
        enable = true;
        mods = [
          "Arc-2.0"
          "context-menu-icons"
          "quick-search-zen-browser"
          "quick-tabs"
          "search-engine-select"
          "zen-auto-expand-sidebar"
          "zen-command-palette"
          "zen-drop-link"
          "2317fd93-c3ed-4f37-b55a-304c1816819e" # Audio Indicator Enhanced
          "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
          "ae7868dc-1fa1-469e-8b89-a5edf7ab1f24" # Load Bar
          "599a1599-e6ab-4749-ab22-de533860de2c" # Pimp your PiP
          "e51b85e6-cef5-45d4-9fff-6986637974e1" # smaller zen toast popup
          "ad97bb70-0066-4e42-9b5f-173a5e42c6fc" # SuperPins
          "f966100a-4fed-4df5-a082-f001c5bd654e" # Tidy Popup & Extension
          "642854b5-88b4-4c40-b256-e035532109df" # Transparent Zen
          "4c2bec61-7f6c-4e5c-bdc6-c9ad1aba1827" # Vertical Split Tab Groups
          "e9dae25b-2ddd-4245-8581-a6dcf6d35b82" # Zen Custom URL Bar
        ];
      };
    };
  };
}
