{ inputs, ... }:
{
  flake-file.inputs.gestures.url = "github:ferstar/gestures";

  den.aspects.gestures = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ ydotool ];
        services.udev.extraRules = ''KERNEL=="uinput", MODE="0660", GROUP="input"'';
        programs.ydotool.enable = true;
      };

    provides.to-users.homeManager =
      { self', ... }:
      {
        home.packages = [
          inputs.gestures.packages."x86_64-linux".gestures
          self'.packages.tablet-map
        ];

        xdg.configFile."gestures.kdl".text =
          ''swipe direction="any" fingers=3 mouse-up-delay=500 acceleration=10'';

        systemd.user.services = {
          gestures = {
            Service = {
              ExecStart = "${inputs.gestures.packages."x86_64-linux".gestures}/bin/gestures start";
              ExecReload = "${inputs.gestures.packages."x86_64-linux".gestures}/bin/gestures reload";
              Restart = "no";
              StandardOutput = "journal";
              StandardError = "journal";
            };
            Install.WantedBy = [ "default.target" ];
          };
          tablet-map = {
            Service = {
              ExecStart = "${self'.packages.tablet-map}/bin/tablet_map";
              Restart = "no";
              StandardOutput = "journal";
              StandardError = "journal";
            };
            Install.WantedBy = [ "default.target" ];
          };
        };
      };
  };
}
