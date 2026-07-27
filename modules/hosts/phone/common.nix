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
        pkgs,
        lib,
        ...
      }:
      {
        imports = with inputs; [
          vanilla-mobile-nixos.nixosModules.vanilla-mobile
          inputs.disko-mobile.nixosModules.disko
        ];

        vanilla-mobile = {
          usb-gadget.enable = lib.mkDefault true;
          powerManagement = {
            enable = lib.mkDefault true;
            sleepInhibitors.enableDefault = lib.mkDefault true;
          };

          plymouth = {
            mobileTweaks.enable = lib.mkDefault false;
            unl0krSupport.enable = lib.mkDefault false;
          };
        };

        nixpkgs.config = {
          allowUnfree = true;
          allowUnfreePackages = [ "oneplus-sdm845-firmware" ];
        };

        environment = {
          systemPackages = [ inputs'.vanilla-mobile-nixos.packages.oneplus-sdm845-firmware ];
          enableAllTerminfo = true;
        };

        boot = {
          #  kernelPackages = inputs'.vanilla-mobile.installer.crossPkgs.linuxPackagesFor inputs.vanilla-mobile.installer.vanillaMobileCrossPkgs.linuxKernels.linux_sdm845;
          kernelParams = [
            "console=tty0"
            "firmware_class.path=/extra-firmware"
          ];
          initrd.systemd.package = pkgs.systemd;
          blacklistedKernelModules = [ "ipa" ];
          loader = {
            efi.canTouchEfiVariables = false;
            systemd-boot = lib.mkForce {
              enable = true;
              editor = false;
            };
          };
        };

        hardware = {
          #enableRedistributableFirmware = true;
          firmware = lib.mkAfter [ inputs'.vanilla-mobile-nixos.packages.oneplus-sdm845-firmware ];
          sensor.iio.enable = true;
          deviceTree.enable = true;
        };

        networking.modemmanager.enable = true;
        systemd = {
          sockets.sshd.socketConfig.FreeBind = lib.mkIf config.services.openssh.startWhenNeeded true;
          package =
            let
              pkg = pkgs.systemd;
            in
            pkgs.symlinkJoin {
              inherit (pkg)
                name
                pname
                version
                meta
                passthru
                outputs
                ;
              paths = [ pkg ];
              nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
              postBuild = ''
                ln -s ${pkg.dev} $dev
                ln -s ${pkg.debug} $debug
                ln -s ${pkg.man} $man

                wrapProgram $out/bin/bootctl --set SYSTEMD_RELAX_ESP_CHECKS 1

                rm $out/example/sysctl.d/50-coredump.conf
                substitute ${pkg}/example/sysctl.d/50-coredump.conf $out/example/sysctl.d/50-coredump.conf \
                  --replace-fail "${pkg}" "$out"
              '';
            };
          services = {
            ModemManager.serviceConfig.ExecStart = lib.mkIf config.networking.modemmanager.enable [
              "${pkgs.modemmanager}/bin/ModemManager --test-quick-suspend-resume"
            ];
            iio-sensor-proxy.serviceConfig.TimeoutStopSec = 3;
            usb-moded-turn-off-rescue-mode.enable = false;
          };
        };
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
