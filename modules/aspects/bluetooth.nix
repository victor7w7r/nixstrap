{
  den.aspects.bluetooth.nixos =
    {
      isPersistent,
      lib,
      pkgs,
      ...
    }:
    {
      environment = lib.mkMerge [
        {
          systemPackages = with pkgs; [
            bluetui
            bluetuith
          ];
        }
        (lib.mkIf isPersistent { persistence."/nix/persist".directories = [ "/var/lib/bluetooth" ]; })
      ];

      boot.extraModprobeConfig = "options bluetooth disable_ertm=1 ";
      services.blueman.enable = true;
      systemd.user.services.telephony_client.enable = false;

      hardware.bluetooth = {
        enable = true;
        package = pkgs.bluez5-experimental;
        powerOnBoot = true;
        settings.General = {
          Enable = "Source,Sink,Media,Socket";
          FastConnectable = "true";
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
          Experimental = true;
          Privacy = "device";
        };
      };
    };
}
