{
  den,
  hosts,
  kernel,
  inputs,
  self,
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
      (hosts.lib.zram {
        value = "8G";
        memoryPercent = 100;
      })
      audio._
      cli._
      dev.ccache
      #dev.zed
      dev.tools
      disks
      #gui._
      misc.comm
      misc.fetch
      pentest._
      #zen._

      phone._

      #android
      bluetooth
      emulation
      firewall
      games
      #kitty
      #libvirt
      #plasma._
      #remote
      root
      secrets
      tools
      victor7w7r
      #virt
      #waydroid
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
        imports = [ inputs.vanilla-mobile-nixos.nixosModules.vanilla-mobile ];

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

          deviceInfo = {
            name = "OnePlus 6";
            manufacturer = "OnePlus";
          };
        };

        nixpkgs.config.allowUnfreePackages = [ "oneplus-sdm845-firmware" ];

        environment = {
          systemPackages = [ inputs'.vanilla-mobile-nixos.packages.oneplus-sdm845-firmware ];
          enableAllTerminfo = true;
        };

        boot = {
          kernelPackages =
            (kernel.hosts.phone pkgs "phone" "aarch64-linux" pkgs.stdenv.hostPlatform.system)
            .phone-kernelPackages;

          kernelParams = [
            "console=tty0"
            "zram.num_devices=2"
            "firmware_class.path=/extra-firmware"
          ];
          blacklistedKernelModules = [
            "ath10k_core"
            "ath10k_pci"
            "ipa"
          ];
          loader = {
            efi.canTouchEfiVariables = false;
            systemd-boot = lib.mkForce {
              enable = true;
              editor = false;
              configurationLimit = 20;
              extraFiles = {
                "EFI/uefi.img" = "${self}/assets/sdm845/uefi.img";
                "EFI/shell.efi" = "${pkgs.edk2-uefi-shell}/shell.efi";
                "EFI/tools/poweroff.nsh" = pkgs.writeText "poweroff.nsh" "reset -s";
                "EFI/tools/reboot.nsh" = pkgs.writeText "reboot.nsh" "reset -c";
              };
              extraEntries = {
                "uefi.conf" = ''
                  title UEFI
                  efi /EFI/uefi.img
                '';
                "poweroff.conf" = ''
                  title      Apagar (Poweroff)
                  efi        /EFI/shell.efi
                  options    -e -noexit /EFI/tools/poweroff.nsh
                '';
                "reboot.conf" = ''
                  title      Reiniciar (Reboot)
                  efi        /EFI/shell.efi
                  options    -e -noexit /EFI/tools/reboot.nsh
                '';
              };
            };
          };
        };

        hardware = {
          firmwareCompression = lib.mkForce "zstd";
          firmware = [
            (inputs'.vanilla-mobile-nixos.packages.oneplus-sdm845-firmware.overrideAttrs (oldAttrs: {
              postInstall = (oldAttrs.postInstall or "") + ''
                rm -rf $out/lib/firmware/ath10k
                mkdir -p $out/lib/firmware/ath10k
              '';
            }))
          ];
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
          };
        };
        security.pam.services.sshd.allowNullPassword = lib.mkForce true;
      };
  };
  /*
    // (lib.optionalAttrs pkgs.stdenv.buildPlatform.isx86_64 {
    _module.args.pkgs = armPkgs;
    })
  */
}
