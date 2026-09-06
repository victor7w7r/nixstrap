{
  den.aspects.dev.mise =
    { user, ... }:
    {
      nixos = { lib, pkgs, ... }: {
        environment = {
          systemPackages = with pkgs; [
            fvm
            mise
          ];
          persistence."/nix/persist".users."${user.name}".directories = lib.mkAfter [
            ".cache/mise"
            ".local/share/mise"
            ".cargo"
            ".rustup"
          ];
        };
      };

      provides.to-users.homeManager.programs.mise = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        globalConfig = {
          tools = {
            bun = "1.3";
            node = "24";
          };
          settings = {
            trusted_config_paths = [ "~/repositories" ];
            node.compile = false;
            npm.bun = true;
          };
        };
      };
    };
}
