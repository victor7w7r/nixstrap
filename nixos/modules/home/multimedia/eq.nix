{ ... }:
{
  services.easyeffects = {
    enable = true;
    output-comp = {
      "output" = {
        "bass_enhancer#0" = {
          "amount" = 0.0;
          "blend" = 3.0;
          "bypass" = false;
          "floor" = 20.0;
          "floor-active" = false;
          "harmonics" = 8.5;
          "input-gain" = 0.2;
          "output-gain" = 0.0;
          "scope" = 100.0;
        };
        "bass_loudness#0" = {
          "bypass" = false;
          "input-gain" = -1.9;
          "link" = -9.299999999999999;
          "loudness" = -3.4000000000000004;
          "output" = -4.700000000000005;
          "output-gain" = 0.0;
        };
        "blocklist" = [
          "qemu"
        ];
        "crystalizer#0" = {
          "adaptive-intensity" = true;
          "band0" = {
            "bypass" = false;
            "intensity" = 4.0;
            "mute" = false;
          };
          "band1" = {
            "bypass" = false;
            "intensity" = 2.0;
            "mute" = false;
          };
          "band10" = {
            "bypass" = false;
            "intensity" = -10.0;
            "mute" = false;
          };
          "band11" = {
            "bypass" = false;
            "intensity" = -9.0;
            "mute" = false;
          };
          "band12" = {
            "bypass" = false;
            "intensity" = -8.0;
            "mute" = false;
          };
          "band2" = {
            "bypass" = false;
            "intensity" = 1.0;
            "mute" = false;
          };
          "band3" = {
            "bypass" = false;
            "intensity" = -1.0;
            "mute" = false;
          };
          "band4" = {
            "bypass" = false;
            "intensity" = -2.0;
            "mute" = false;
          };
          "band5" = {
            "bypass" = false;
            "intensity" = -6.0;
            "mute" = false;
          };
          "band6" = {
            "bypass" = false;
            "intensity" = -6.0;
            "mute" = false;
          };
          "band7" = {
            "bypass" = false;
            "intensity" = -10.0;
            "mute" = false;
          };
          "band8" = {
            "bypass" = false;
            "intensity" = -8.0;
            "mute" = false;
          };
          "band9" = {
            "bypass" = false;
            "intensity" = -9.0;
            "mute" = false;
          };
          "bypass" = false;
          "fixed-quantum" = false;
          "input-gain" = 0.0;
          "output-gain" = 0.1;
          "oversampling" = true;
          "oversampling-quality" = 5.0;
          "transition-band" = 120.0;
        };
        "equalizer#0" = {
          "balance" = 0.0;
          "bypass" = false;
          "input-gain" = 3.5;
          "left" = {
            "band0" = {
              "frequency" = 22.4;
              "gain" = 7.870000000000001;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band1" = {
              "frequency" = 27.8;
              "gain" = 1.5900000000000007;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band10" = {
              "frequency" = 194.06;
              "gain" = 1.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band11" = {
              "frequency" = 240.81;
              "gain" = -1.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band12" = {
              "frequency" = 298.834;
              "gain" = -4.59;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band13" = {
              "frequency" = 370.834;
              "gain" = -0.16;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band14" = {
              "frequency" = 460.182;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band15" = {
              "frequency" = 571.057;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band16" = {
              "frequency" = 708.647;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band17" = {
              "frequency" = 879.387;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band18" = {
              "frequency" = 1091.26;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band19" = {
              "frequency" = 1354.19;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band2" = {
              "frequency" = 34.51;
              "gain" = -4.419999999999999;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band20" = {
              "frequency" = 1680.47;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band21" = {
              "frequency" = 2085.35;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band22" = {
              "frequency" = 2587.79;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band23" = {
              "frequency" = 3211.29;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band24" = {
              "frequency" = 3985.01;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band25" = {
              "frequency" = 4945.15;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band26" = {
              "frequency" = 6136.63;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band27" = {
              "frequency" = 7615.17;
              "gain" = 0.79;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band28" = {
              "frequency" = 9449.96;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band29" = {
              "frequency" = 11726.8;
              "gain" = 2.36;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band3" = {
              "frequency" = 42.82;
              "gain" = -2.4199999999999995;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band30" = {
              "frequency" = 14552.2;
              "gain" = 9.73;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band31" = {
              "frequency" = 18087.0;
              "gain" = 16.12;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band4" = {
              "frequency" = 53.14;
              "gain" = -0.03999999999999925;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band5" = {
              "frequency" = 65.95;
              "gain" = 0.09000000000000075;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band6" = {
              "frequency" = 81.83;
              "gain" = -0.53;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band7" = {
              "frequency" = 101.55;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band8" = {
              "frequency" = 126.0;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band9" = {
              "frequency" = 156.38;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
          };
          "mode" = "IIR";
          "num-bands" = 32;
          "output-gain" = 0.0;
          "pitch-left" = 0.0;
          "pitch-right" = 0.0;
          "right" = {
            "band0" = {
              "frequency" = 22.4;
              "gain" = 7.870000000000001;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band1" = {
              "frequency" = 27.8;
              "gain" = 1.5900000000000007;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band10" = {
              "frequency" = 194.06;
              "gain" = 1.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band11" = {
              "frequency" = 240.81;
              "gain" = -1.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band12" = {
              "frequency" = 298.834;
              "gain" = -4.59;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band13" = {
              "frequency" = 370.834;
              "gain" = -0.16;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band14" = {
              "frequency" = 460.182;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band15" = {
              "frequency" = 571.057;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band16" = {
              "frequency" = 708.647;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band17" = {
              "frequency" = 879.387;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band18" = {
              "frequency" = 1091.26;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band19" = {
              "frequency" = 1354.19;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band2" = {
              "frequency" = 34.51;
              "gain" = -4.419999999999999;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band20" = {
              "frequency" = 1680.47;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band21" = {
              "frequency" = 2085.35;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band22" = {
              "frequency" = 2587.79;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band23" = {
              "frequency" = 3211.29;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band24" = {
              "frequency" = 3985.01;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band25" = {
              "frequency" = 4945.15;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band26" = {
              "frequency" = 6136.63;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band27" = {
              "frequency" = 7615.17;
              "gain" = 0.79;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band28" = {
              "frequency" = 9449.96;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band29" = {
              "frequency" = 11726.8;
              "gain" = 2.36;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band3" = {
              "frequency" = 42.82;
              "gain" = -2.4199999999999995;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band30" = {
              "frequency" = 14552.2;
              "gain" = 9.73;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band31" = {
              "frequency" = 18087.0;
              "gain" = 16.12;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band4" = {
              "frequency" = 53.14;
              "gain" = -0.03999999999999925;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band5" = {
              "frequency" = 65.95;
              "gain" = 0.09000000000000075;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band6" = {
              "frequency" = 81.83;
              "gain" = -0.53;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band7" = {
              "frequency" = 101.55;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band8" = {
              "frequency" = 126.0;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
            "band9" = {
              "frequency" = 156.38;
              "gain" = 0.0;
              "mode" = "RLC (BT)";
              "mute" = false;
              "q" = 4.36;
              "slope" = "x1";
              "solo" = false;
              "type" = "Bell";
              "width" = 4.0;
            };
          };
          "split-channels" = false;
        };
        "filter#0" = {
          "balance" = 0.0;
          "bypass" = true;
          "equal-mode" = "IIR";
          "frequency" = 2000.0;
          "gain" = 0.0;
          "input-gain" = 0.0;
          "mode" = "RLC (BT)";
          "output-gain" = 0.0;
          "quality" = 0.0;
          "slope" = "x1";
          "type" = "Resonance";
          "width" = 4.0;
        };
        "pitch#0" = {
          "anti-alias" = false;
          "bypass" = true;
          "cents" = 23.0;
          "dry" = -100.0;
          "input-gain" = 0.0;
          "octaves" = 0.0;
          "output-gain" = 0.0;
          "overlap-length" = 21;
          "quick-seek" = false;
          "rate-difference" = 0.0;
          "seek-window" = 15;
          "semitones" = 0.0;
          "sequence-length" = 40;
          "tempo-difference" = 0.0;
          "wet" = 0.0;
        };
        "plugins_order" = [
          "equalizer#0"
          "pitch#0"
          "crystalizer#0"
          "bass_loudness#0"
          "bass_enhancer#0"
          "filter#0"
        ];
      };
    };
  };
}
