{ inputs, ... }:
{
  imports = [
    (import ./lib/qcom-845.nix)
    (import "${inputs.mobile-nixos}/modules/module-list.nix")
  ];

  mobile = {
    system.android.device_name = "OnePlus6T";
    device = {
      name = "oneplus-fajita";
      supportLevel = "best-effort";
      identity.name = "OnePlus 6T";
    };
    hardware.screen.height = 2340;
  };
}
