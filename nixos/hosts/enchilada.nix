{ inputs, ... }:
{
  imports = [
    (import ./lib/qcom-845.nix)
    (import "${inputs.mobile-nixos}/modules/module-list.nix")
  ];

  mobile = {
    system.android.device_name = "OnePlus6";
    device = {
      name = "oneplus-enchilada";
      supportLevel = "supported";
      identity.name = "OnePlus 6";
    };
    hardware.screen.height = 2280;
  };
}
