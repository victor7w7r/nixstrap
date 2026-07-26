{
  den,
  inputs,
  tarball,
  ...
}:
{
  flake-file.inputs = {
    vanilla-mobile-nixos.url = "github:vanilla-mobile-nixos/vanilla-mobile-nixos";
    disko-mobile = {
      url = "github:JuneStepp/disko/mobile";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.phone.common = {
    includes = with den.aspects; [
      (tarball.lib.call { })
      audio._
      cli._
      dev.ccache
      dev.zed
      dev.tools
      gui._
      misc.comm
      misc.fetch
      pentest._
      zen._

      phone._
      android
      bluetooth
      kitty
      libvirt
      plasma._
      secrets
      victor7w7r
      waydroid
    ];

    nixos =
      {
        config,
        inputs',
        lib,
        ...
      }:
      {
        imports = with inputs; [
          vanilla-mobile-nixos.nixosModules.vanilla-mobile
        ];

        nixpkgs.config.allowUnfreePackages = [ "oneplus-sdm845-firmware" ];

        environment = {
          systemPackages = [ inputs'.vanilla-mobile-nixos.packages.oneplus-sdm845-firmware ];
          enableAllTerminfo = true;
        };

        boot = {
          kernelPackages = inputs'.vanilla-mobile.installer.crossPkgs.linuxPackagesFor inputs.vanilla-mobile.installer.vanillaMobileCrossPkgs.linuxKernels.linux_sdm845;
          kernelParams = [
            "console=tty0"
            "firmware_class.path=/extra-firmware"
          ];
          blacklistedKernelModules = [ "ipa" ];
          loader = {
            efi.canTouchEfiVariables = false;
            systemd-boot = lib.mkForce {
              enable = true;
              editor = false;
            };
          };
        };

        hardware.enableRedistributableFirmware = true;
        networking.modemmanager.enable = true;
        systemd.services.usb-moded-turn-off-rescue-mode.enable = false;
        systemd.sockets.sshd.socketConfig.FreeBind = lib.mkIf config.services.openssh.startWhenNeeded true;
        security.pam.services.sshd.allowNullPassword = lib.mkImageMediaOverride true;

        zramSwap = {
          enable = true;
          algorithm = "zstd";
          memoryPercent = 60;
          priority = 100;
        };
      };
  };
}
