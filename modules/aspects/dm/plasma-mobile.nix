{
  den.aspects.plasma-mobile = {
    nixos =
      { pkgs, ... }:
      {
        services.displayManager.sddm.enable = true;
        services.xserver.enable = true;

        environment.etc.
        environment.systemPackages = with pkgs.kdePackages; [
          plasma-mobile
          plasma-nano
          plasma-dialer
          spacebar
          pkgs.maliit-framework
          pkgs.maliit-keyboard
        ];
      };
  };
}
