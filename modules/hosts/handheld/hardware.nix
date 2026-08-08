{
  den.aspects.handheld.hardware.nixos =
    { lib, pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.writeScriptBin "charge-upto" ''
          #!${pkgs.bash}/bin/bash
          echo ''${1:-100} > /sys/class/power_supply/BAT?/charge_control_end_threshold
        '')
      ];

      hardware = {
        firmware = with pkgs; lib.mkAfter [ xone-dongle-firmware ];
        xone.enable = true;
        amdgpu = {
          opencl.enable = true;
          initrd.enable = true;
        };
        cpu.amd.updateMicrocode = true;
      };

      services = {
        xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
        udev.extraRules = ''
          ACTION=="add", SUBSYSTEM=="pci", DRIVER=="amdgpu", ATTR{power_dpm_force_performance_level}="auto", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="2808", ATTR{idProduct}=="a753", MODE="0660", GROUP="input"
        '';
        fprintd = {
          enable = true;
          /*
            package = pkgs.fprintd.override {
              libfprint = pkgs.callPackage ./custom/focaltech.nix { };
              };
          */
        };
      };
    };
}
