{
  den.aspects.audio.pipewire.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ qpwgraph ];
      services.pipewire = {
        enable = true;
        package = pkgs.pipewire;
        /*
          lib.mkForce (
          if host == "v7w7r-macmini81" then audioT2.pipewirePackage else
          );
        */
        extraConfig.pipewire = {
          "10-clock-quantum"."context.properties"."default.clock.min-quantum" = 1024;
          "99-allowed-rates"."context.properties"."default.clock.allowed-rates" = [
            44100
            48000
            88200
            96000
            176400
            192000
          ];
        };
        alsa = {
          enable = true;
          support32Bit = true;
        };
        jack.enable = true;
        pulse.enable = true;
        socketActivation = true;
        wireplumber = {
          enable = true;
          package = pkgs.wireplumber;
          /*
            if host == "v7w7r-macmini81" then
              lib.mkForce (pkgs.wireplumber.override { pipewire = audioT2.pipewirePackage; })
            else
              pkgs.wireplumber;
          */
        };
      };
    };
}
