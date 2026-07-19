{
  den.aspects.main.audio.nixos =
    { self', ... }:
    {
      environment.etc = {
        "alsa-card-profile/mixer/paths".source =
          "${self'.packages.t2-audio}/share/apple-t2-better-audio/files/paths";
        "alsa-card-profile/mixer/profile-sets-base".source =
          "${self'.packages.t2-audio}/share/apple-t2-better-audio/files/profile-sets";
        "alsa-card-profile/mixer/profile-sets/apple-t2x1.conf".text = ''
          [General]
          auto-profiles = yes

          [Mapping Speakers]
          device-strings = hw:%f,0
          paths-output = analog-output-mono
          channel-map = mono
          direction = output

          [Mapping Headphones]
          device-strings = hw:%f,2
          paths-output = t2-headphones
          channel-map = left,right
          direction = output

          [Mapping HeadsetMic]
          device-strings = hw:%f,3
          paths-input = t2-headset-mic
          channel-map = mono
          direction = input

          [Profile Default]
          description = Default Profile
          output-mappings = Speakers Headphones
          input-mappings = HeadsetMic
        '';
      };
    };
}
