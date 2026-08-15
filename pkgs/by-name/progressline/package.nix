{ pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "progressline";
  version = "latest";
  nativeBuildInputs = with pkgs; [ unzip ];
  src =
    if pkgs.stdenvNoCC.hostPlatform.isAarch64 then
      pkgs.fetchurl {
        url = "https://github.com/kattouf/ProgressLine/releases/download/0.2.4/progressline-0.2.4-aarch64-unknown-linux-gnu.zip";
        sha256 = "sha256-6aZuKn1LpsEhX23V9O2Y08zbZM2SckAh3R5uI+0isKE=";
      }
    else
      pkgs.fetchurl {
        url = "https://github.com/kattouf/ProgressLine/releases/download/0.2.4/progressline-0.2.4-x86_64-unknown-linux-gnu.zip";
        sha256 = "sha256-dr+U9v9WtZGrJGoQbRF29MIM5CvRO1+jjNTUJschGdM=";
      };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin $out/temp
    unzip $src -d $out/temp
    mv $out/temp/progressline $out/bin/
    rm -rf $out/temp
    chmod +x $out/bin/progressline
  '';
}
