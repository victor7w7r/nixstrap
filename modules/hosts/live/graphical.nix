{
  den,
  lib,
  live,
  ...
}:
{
  den = {
    hosts.x86_64-linux.graphical-live.users.snowflake = { };

    aspects.graphical-live = {
      includes = with den.aspects; [
        live.common
        (den.batteries.tty-autologin "snowflake")
        audio._
        cli._
        dev.zed
        gui._

        kitty
        secrets
        snowflake
        xfce
      ];

      nixos = {
        networking.hostName = "v7w7r-live";
        system.nixos.variant_id = lib.mkDefault "graphical";
        isoImage.edition = "xfce";
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
            displayManager = {
              lightdm.enable = lib.mkDefault true;
              autoLogin = {
                enable = true;
                user = "snowflake";
              };
            };
          };
        };
      };

      provides.to-users.homeManager = {
        services.network-manager-applet.enable = true;
        xfconf.settings.xfce4-panel = {
          "panels" = [ 1 ];
          "panels/dark-mode" = true;
          "panels/panel-1/icon-size" = 16;
          "panels/panel-1/length" = 100;
          "panels/panel-1/position" = "p=6;x=0;y=0";
          "panels/panel-1/position-locked" = true;
          "panels/panel-1/size" = 26;
          "panels/panel-1/plugin-ids" = [
            1
            2
            3
            4
            5
            6
            7
            8
            9
            10
            11
          ];

          "plugins/plugin-1" = "applicationsmenu";
          "plugins/plugin-2" = "tasklist";
          "plugins/plugin-3" = "separator";
          "plugins/plugin-4" = "pager";
          "plugins/plugin-5" = "separator";
          "plugins/plugin-6" = "systray";
          "plugins/plugin-7" = "power-manager-plugin";
          "plugins/plugin-8" = "separator";
          "plugins/plugin-9" = "clock";
          "plugins/plugin-10" = "separator";
          "plugins/plugin-11" = "actions";

          "plugins/plugin-1/show-tooltips" = true;
          "plugins/plugin-2/include-all-workspaces" = true;
          "plugins/plugin-3/expand" = true;
          "plugins/plugin-3/style" = 0;
          "plugins/plugin-5/expand" = true;
          "plugins/plugin-5/style" = 0;
          "plugins/plugin-8/style" = 0;
          "plugins/plugin-10/style" = 0;
          "plugins/plugin-11/appearance" = 1;
          "plugins/plugin-11/items" = [
            "+logout-dialog"
            "-switch-user"
            "-separator"
            "-logout"
            "-lock-screen"
            "-hibernate"
            "-hybrid-sleep"
            "+suspend"
            "+restart"
            "+shutdown"
          ];
        };
      };
    };
  };
}
