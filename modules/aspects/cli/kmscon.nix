{
  den.aspects.cli.kmscon.nixos =
    {
      isHandheld,
      isMain,
      lib,
      ...
    }:
    {
      services.kmscon = {
        enable = isHandheld || isMain;
        config = {
          font-size = if isHandheld then 14 else 9;
          font-name = "JetBrainsMono Nerd Font Mono";
          sb-size = 10000;
          hwaccel = false;
          palette = "custom";
          palette-background = "30, 30, 46";
        };
      };

      systemd.services = lib.optionalAttrs (isHandheld || isMain) {
        "getty@tty7".enable = false;
        "autovt@tty7".enable = false;
        "kmsconvt@tty1".enable = false;
        "kmsconvt@tty7".enable = false;
        "getty@tty1".enable = false;
        "autovt@tty1".enable = false;
      };
    };
}
