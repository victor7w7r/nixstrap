{ pkgs, stdenvNoCC, ... }:

stdenvNoCC.mkDerivation {
  pname = "kde-control-station";
  version = "latest";

  src = pkgs.fetchFromGitHub {
    owner = "EliverLara";
    repo = "kde-control-station";
    rev = "plasma6";
    sha256 = "sha256-mMeZ6czgLMiCt1nkZrzm1GUuSfAxnkW1mmXCuW9RPfU=";
  };

  propagatedUserEnvPkgs = with pkgs.kdePackages; [
    plasma-nm
    kdeplasma-addons
    plasma-pa
    powerdevil
    kdeconnect-kde
  ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/KdeControlStation
    cp -r package/* $out/share/plasma/plasmoids/KdeControlStation
    runHook postInstall
  '';

  passthru.updateScript = pkgs.nix-update-script { };
}
