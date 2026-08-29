{ den, inputs, ... }:
{
  perSystem.packages = {
    graphical-live-toplevel =
      inputs.self.nixosConfigurations.graphical-live.config.system.build.toplevel;
    graphical-live-image = inputs.self.nixosConfigurations.graphical-live.config.system.build.isoImage;
  };

  den = {
    hosts.x86_64-linux.graphical-live.users.snowflake = { };
    aspects.graphical-live = {
      includes = with den.aspects; [
        live.common
        dev.zed
        gui._

        kitty
        snowflake
        xfce
      ];

      nixos =
        { lib, ... }:
        {
          system.nixos.variant_id = lib.mkDefault "graphical";
          isoImage = {
            edition = "xfce";
            configurationName = "xfce";
          };
          powerManagement.enable = true;
          hardware.graphics = {
            enable = true;
            enable32Bit = true;
          };

          security.polkit.extraConfig = ''
            polkit.addRule(function(action, subject) {
              if (subject.isInGroup("wheel")) {
                return polkit.Result.YES;
              }
            });
          '';

          services = {
            qemuGuest.enable = true;
            spice-vdagentd.enable = true;
            xe-guest-utilities.enable = false;
            xserver = {
              exportConfiguration = true;
              displayManager.autoLogin = {
                enable = true;
                user = "snowflake";
              };
            };
          };
        };
    };
  };
}
