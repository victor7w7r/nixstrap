{
  den.aspects.cli.kmscon.nixos = {
    services.kmscon = {
      enable = true;
      config = {
        font-size = 9;
        font-name = "JetBrainsMono Nerd Font Mono";
        sb-size = 10000;
        hwaccel = false;
        palette = "custom";
        palette-background = "30, 30, 46";
      };
    };

    systemd.services = {
      "getty@tty7".enable = false;
      "autovt@tty7".enable = false;
      "kmsconvt@tty1".enable = false;
      "kmsconvt@tty7".enable = false;
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };
}
