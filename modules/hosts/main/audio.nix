{
  den.aspects.main.audio.nixos =
    { self', ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          pipewire = prev.pipewire.overrideAttrs (oldAttrs: {
            postPatch = (oldAttrs.postPatch or "") + ''
              cp -r ${self'.packages.t2-audio.files}/files/{profile-sets,paths} spa/plugins/alsa/mixer/

              cat > spa/plugins/alsa/mixer/profile-sets/apple-t2x1.conf << EOF
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
              EOF
            '';
          });
          wireplumber = prev.wireplumber.override { pipewire = final.pipewire; };
        })
      ];
    };
}
