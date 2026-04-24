{
  lib,
  pkgs,
  ...
}:
{
  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_INPUT}=="1", SUBSYSTEMS=="input", ATTRS{name}=="pmi8998_haptics", TAG+="uaccess", ENV{FEEDBACKD_TYPE}="vibra"
    SUBSYSTEM=="misc", KERNEL=="fastrpc-*", ENV{ACCEL_MOUNT_MATRIX}+="-1, 0, 0; 0, -1, 0; 0, 0, -1"
  '';
  environment.systemPackages = [ (pkgs.callPackage ../custom/sdm845-alsa.nix { }) ];
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.enable32Bit = lib.mkForce false;
  mobile.quirks.qualcomm.sdm845-modem.enable = true;
  mobile.quirks.audio.alsa-ucm-meld = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "firmware-oneplus-sdm845"
      "firmware-oneplus-sdm845-xz"
    ];
  hardware.firmware = lib.mkAfter [ (pkgs.callPackage ../custom/oneplus.nix { }) ];

  systemd.services.ModemManager.serviceConfig.ExecStart = [
    ""
    "${pkgs.modemmanager}/bin/ModemManager --test-quick-suspend-resume"
  ];

}
