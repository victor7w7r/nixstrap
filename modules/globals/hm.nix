{ flakelib, lib, ... }:
{
  den = {
    schema.user.classes = lib.mkDefault [ "homeManager" ];
    default = {
      os.home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm-backup";
        sharedModules = [
          (
            { ... }:
            {
              programs.home-manager.enable = true;
              home = {
                enableNixpkgsReleaseCheck = false;
                language.base = "es_ES.UTF-8";
              };
              manual = {
                html.enable = lib.mkDefault false;
                json.enable = lib.mkDefault false;
                manpages.enable = lib.mkDefault false;
              };
            }
          )
        ];
      };
      nixos =
        { pkgs, ... }:
        {
          home-manager = {
            backupCommand = "${pkgs.trash-cli}/bin/trash";
            sharedModules = [
              (
                { ... }:
                {
                  systemd.user.startServices = "sd-switch";
                  home.stateVersion = flakelib.config.stateVersion;
                }
              )
            ];
          };
        };
    };
  };
}
