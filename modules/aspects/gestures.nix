{ inputs, ... }:
{
  flake-file.inputs.gestures.url = "github:ferstar/gestures";

  den.aspects.gestures = {
    nixos.services.udev.extraRules = ''KERNEL=="uinput", MODE="0660", GROUP="input"'';

    provides.to-users.homeManager =
      { pkgs, self', ... }:
      {
        home.packages = [
          inputs.gestures.packages."x86_64-linux".gestures
          self'.packages.tablet-map
          pkgs.ydotool
        ];

        xdg.configFile."gestures.kdl".text =
          ''swipe direction="any" fingers=3 mouse-up-delay=500 acceleration=10'';

        systemd.user.services = {
          ydotoold = {
            Service = {
              ExecStart = "${pkgs.ydotool}/bin/ydotoold --socket-path=%t/.ydotool_socket";
              Restart = "always";
              RestartSec = "2s";
            };
            Install.WantedBy = [ "default.target" ];
          };
          gestures = {
            Unit = {
              Description = "Libinput gestures service";
              Requires = [ "ydotoold.service" ];
              After = [ "ydotoold.service" ];
              BindsTo = [ "ydotoold.service" ];
            };
            Service = {
              ExecStart = "${inputs.gestures.packages."x86_64-linux".gestures}/bin/gestures start";
              ExecReload = "${inputs.gestures.packages."x86_64-linux".gestures}/bin/gestures reload";
              Restart = "always";
              RestartSec = "3s";
              StandardOutput = "journal";
              StandardError = "journal";
            };
            Install.WantedBy = [ "default.target" ];
          };
          tablet-map = {
            Unit = {
              Description = "Tablet Map daemon";
              Requires = [ "ydotoold.service" ];
              After = [ "ydotoold.service" ];
              BindsTo = [ "ydotoold.service" ];
            };
            Service = {
              ExecStart = "${self'.packages.tablet-map}/bin/tablet_map";
              Restart = "always";
              RestartSec = "3s";
              StandardOutput = "journal";
              StandardError = "journal";
            };
            Install.WantedBy = [ "default.target" ];
          };
        };
      };
  };
}
