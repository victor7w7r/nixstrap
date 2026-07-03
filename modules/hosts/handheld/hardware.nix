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
        #bolt.enable = true;
        amdgpu = {
          opencl.enable = true;
          initrd.enable = true;
        };
        cpu.amd.updateMicrocode = true;
        xone.enable = true;
      };

      services = {
        xserver.videoDrivers = lib.mkDefault [ "modesetting" ];
        udev.extraRules = ''
          ACTION=="add", SUBSYSTEM=="pci", DRIVER=="amdgpu", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/%p/power_dpm_force_performance_level /sys/%p/pp_od_clk_voltage"
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
