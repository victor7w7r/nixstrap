{
  den.aspects.phone.audio.nixos = { inputs', ... }: {
    vanilla-mobile.alsa-ucm-conf = {
      enable = true;
      package = inputs'.vanilla-mobile.packages.alsa-ucm-conf-sdm845;
    };

    services = {
      q6voiced = {
        enable = true;
        settings = {
          q6voice_card = 0;
          q6voice_device = 6;
        };
      };
      pipewire.wireplumber.extraConfig."51-qcom"."monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "~alsa_input.*"; }
            { "node.name" = "~alsa_output.*"; }
          ];

          actions.update-props = {
            "audio.format" = "S16LE";
            "audio.rate" = 48000;
            "api.alsa.period-size" = 4096;
            "api.alsa.period-num" = 6;
            "api.alsa.headroom" = 512;
          };
        }
      ];
    };
  };
}
