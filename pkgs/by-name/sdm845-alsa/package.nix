{ inputs, stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "alsa-ucm-conf";
  version = "unstable-2022-12-08";
  src = inputs.sdm845-alsa;
  installPhase = ''
    substituteInPlace ucm2/lib/card-init.conf --replace '"/bin' '"/run/current-system/sw/bin'
    mkdir -p "$out"/share/alsa/ucm2/{OnePlus,conf.d/sdm845,lib}
    mv ucm2/lib/card-init.conf "$out/share/alsa/ucm2/lib/"
    mv ucm2/OnePlus/enchilada "$out/share/alsa/ucm2/OnePlus/"
    ln -s ../../OnePlus/enchilada/enchilada.conf "$out/share/alsa/ucm2/conf.d/sdm845/oneplus-OnePlus6-Unknown.conf"
  '';
  meta.priority = -10;
}
