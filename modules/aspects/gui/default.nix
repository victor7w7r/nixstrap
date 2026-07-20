{
  den.aspects.gui.default-config = {
    nixos =
      { lib, pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          libinput
          evemu
        ];

        hardware.uinput.enable = true;
        services = {
          gvfs.enable = true;
          xserver.enable = lib.mkForce true;
          libinput = {
            enable = true;
            mouse.accelProfile = "flat";
            touchpad = {
              naturalScrolling = true;
              accelProfile = "flat";
              tapping = true;
              accelSpeed = "0.75";
            };
          };
        };
      };

    provides.to-users.homeManager = {
      xdg.configFile."xkb/symbols/custom".text = ''
         hidden partial modifier_keys
         xkb_symbols "caps_lock_instant" {
        	key <CAPS> {
         		type="ALPHABETIC",
         		repeat=No,
         		symbols[Group1] = [ Caps_Lock, Caps_Lock ],
         		actions[Group1] = [ LockMods(modifiers=Lock),
        			LockMods(modifiers=Shift+Lock,affect=unlock) ]
        	};
         };
      '';
      xdg.configFile."xkb/rules/evdev".text = ''
        ! option                  = symbols
          custom:caps_lock_instant = +custom(caps_lock_instant)

        ! include %S/evdev
      '';
    };
  };
}
