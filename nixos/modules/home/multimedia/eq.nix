{ ... }:
{
  services.easyeffects.enable = true;
  xdg.configFile =
    let
      dir = "easyeffects/db";
    in
    {
      "${dir}/easyeffectsrc".text = ''
        [StreamInputs]
        inputDevice=alsa_input.usb-046d_C922_Pro_Stream_Webcam_F3B8EEAF-02.iec958-stereo

        [StreamOutputs]
        blocklist=qemu
        outputDevice=alsa_output.pci-0000_02_00.3.Headphones
        plugins=equalizer#0,crystalizer#0,bass_loudness#0,bass_enhancer#0,pitch#0,filter#0
        visiblePage=pluginsPage
        visiblePlugin=pitch#0

        [Window]
        height=736
        lastLoadedOutputPreset=test
        width=1360
      '';

      "${dir}/bassEnhancerrc".text = ''
        [soe][BassEnhancer#0]
        blend=3
        inputGain=0.2
      '';

      "${dir}/bassLoudnessrc".text = ''
        [soe][BassLoudness#0]
        inputGain=-1.9
        link=-9.299999999999999
        loudness=-3.4000000000000004
        output=-4.700000000000005
      '';

      "${dir}/crystalizerrc".text = ''
        [soe][Crystalizer#0]
        intensityBand0=4
        intensityBand1=2
        intensityBand10=-10
        intensityBand11=-9
        intensityBand12=-8
        intensityBand2=1
        intensityBand3=-1
        intensityBand4=-2
        intensityBand5=-6
        intensityBand6=-6
        intensityBand7=-10
        intensityBand8=-8
        intensityBand9=-9
        outputGain=0.1
      '';

      "${dir}/equalizerrc".text = ''
        [soe][Equalizer#0]
        inputGain=3.5

        [soe][Equalizer#0#left]
        band0Gain=7.870000000000001
        band10Gain=1
        band11Gain=-1
        band12Gain=-4.59
        band13Gain=-0.16
        band1Gain=1.5900000000000007
        band27Gain=0.79
        band29Gain=2.36
        band2Gain=-4.419999999999999
        band30Gain=9.73
        band31Frequency=18087
        band31Gain=16.12
        band3Gain=-2.4199999999999995
        band4Gain=-0.03999999999999925
        band5Gain=0.09000000000000075
        band6Gain=-0.53

        [soe][Equalizer#0#right]
        band0Gain=7.870000000000001
        band10Gain=1
        band11Gain=-1
        band12Gain=-4.59
        band13Gain=-0.16
        band1Gain=1.5900000000000007
        band27Gain=0.79
        band29Gain=2.36
        band2Gain=-4.419999999999999
        band30Gain=9.73
        band31Frequency=18087
        band31Gain=16.12
        band3Gain=-2.4199999999999995
        band4Gain=-0.03999999999999925
        band5Gain=0.09000000000000075
        band6Gain=-0.53
      '';

      "${dir}/filterrc".text = ''
        [soe][Filter#0]
        bypass=true
        type=7
      '';

      "${dir}/pitchrc".text = ''
        [soe][Pitch#0]
        bypass=true
        cents=50
        overlapLength=21
        semitones=1
      '';
    };
}
