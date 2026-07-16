{ inputs, pkgs }:
pkgs.stdenvNoCC.mkDerivation {
  pname = "kde-control-station";
  version = "plasma6";
  src = inputs.kde-control-station;

  propagatedUserEnvPkgs = with pkgs.kdePackages; [
    kdeconnect-kde
    kdeplasma-addons
    plasma-nm
    plasma-pa
    powerdevil
  ];

  dontWrapQtApps = true;
  installPhase = ''
    mkdir -p $out/share/plasma/plasmoids/KdeControlStation
    cp -r package/* $out/share/plasma/plasmoids/KdeControlStation
  '';
  passthru.updateScript = pkgs.nix-update-script { };
}
