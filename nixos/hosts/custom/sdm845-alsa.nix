{ stdenvNoCC, fetchFromGitLab, ... }:
stdenvNoCC.mkDerivation {
  pname = "alsa-ucm-conf-enchilada";
  version = "unstable-2022-12-08";
  src = fetchFromGitLab {
    owner = "sdm845-mainline";
    repo = "alsa-ucm-conf";
    rev = "aaa7889f7a6de640b4d78300e118457335ad16c0";
    hash = "sha256-2P5ZTrI1vCJ99BcZVPlkH4sv1M6IfAlaXR6ZjAdy4HQ=";
  };
  installPhase = ''
    substituteInPlace ucm2/lib/card-init.conf --replace '"/bin' '"/run/current-system/sw/bin'
    mkdir -p "$out"/share/alsa/ucm2/{OnePlus,conf.d/sdm845,lib}
    mv ucm2/lib/card-init.conf "$out/share/alsa/ucm2/lib/"
    mv ucm2/OnePlus/enchilada "$out/share/alsa/ucm2/OnePlus/"
    ln -s ../../OnePlus/enchilada/enchilada.conf "$out/share/alsa/ucm2/conf.d/sdm845/oneplus-OnePlus6-Unknown.conf"
  '';
  meta.priority = -10;
}
