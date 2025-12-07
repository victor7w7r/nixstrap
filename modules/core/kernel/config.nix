{ lib, pkgs, ... }:
{
  boot = {
    kernelModules = lib.mkAfter [ "ntsync" ];
    kernelPackages = pkgs.linuxPackages;
    modprobeConfig.enable = true;

    binfmt = {
      enable = true;
      emulatedSystems = [ "aarch64-linux" ];
    };

    loader = {
      efi = {
        efiSysMountPoint = "/boot/EFI";
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = false;
      grub.enable = false;
    };

    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };

    extraModprobeConfig = ''
      blacklist iTCO_wdt
      blacklist joydev
      blacklist mousedev
      blacklist mac_hid
      blacklist intel_hid
    '';
  };

  console = {
    enable = true;
    packages = [ pkgs.spleen ];
    earlySetup = true;
    font = "spleen-8x16";
    keyMap = "us";
  };

}
