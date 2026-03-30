{ pkgs, ... }:
let
  audio = (pkgs.callPackage ../../../../hosts/custom/apple-t2-better-audio.nix { });
  overrideAudioFiles =
    package: pluginsPath:
    package.overrideAttrs (
      _new: old: {
        preConfigurePhases = old.preConfigurePhases or [ ] ++ [ "postPatchPhase" ];
        postPatchPhase = ''
          cp -r ${audio.audioFiles}/files/{profile-sets,paths} ${pluginsPath}/alsa/mixer/
          ${pkgs.coreutils}/bin/cat > ${pluginsPath}/alsa/mixer/profile-sets/apple-t2x1.conf << EOF
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
            description = Deult Profile
            output-mappings = Speakers Headphones
            input-mappings = HeadsetMic
          EOF
        '';
      }
    );

  pipewirePackage = overrideAudioFiles pkgs.pipewire "spa/plugins/";
in
{
  inherit pipewirePackage;
}
