{
  den,
  inputs,
  kernel,
  hosts,
  tarball,
  sdcard,
  ...
}:
{
  perSystem.packages = {
    superlab-toplevel = inputs.self.nixosConfigurations.superlab.config.system.build.toplevel;
    superlab-image = inputs.self.nixosConfigurations.superlab-sdimage.config.system.build.sdImage;
    superlab-mktarball = inputs.self.nixosConfigurations.superlab-tarball.config.system.build.tarball;
    superlab-boot = inputs.self.nixosConfigurations.superlab-tarball.config.system.build.bootFiles;
  };

  den = {
    hosts.aarch64-linux = {
      superlab.users = {
        #root = { };
        victor7w7r = { };
      };
      superlab-sdimage.users = {
        root = { };
        victor7w7r = { };
      };
      superlab-tarball.users = {
        root = { };
        victor7w7r = { };
      };
    };

    aspects = {
      superlab-sdimage.includes = with den.aspects; [
        superlab.common
        (sdcard.lib.call {
          nextPartSize = "65536";
          isHDD = false;
          isEntireDisk = true;
        })
      ];
      superlab-tarball.includes = with den.aspects; [
        superlab.common
        (tarball.lib.call { })
      ];
      superlab = {
        includes = with den.aspects; [ superlab.common ];
        common = {
          includes = with den.aspects; [
            (hosts.lib.zram { })
            superlab.disks

            audio._
            cli._
            dev._
            disks
            #gui._
            misc.comm
            misc.fetch
            pentest._
            #zen._

            #android
            bluetooth
            cockpit
            emulation
            firewall
            games
            #kitty
            #virt
            #libvirt
            #plasma._
            remote
            secrets
            victor7w7r
            root
            tools
            #waydroid
            #xr
          ];

          nixos =
            {
              lib,
              pkgs,
              armPkgs,
              self',
              ...
            }:
            {
              networking.hostName = "v7w7r-radxarock5b";
              boot = {
                kernelParams = [
                  "console=ttyS2,1500000n8"
                  "zram.num_devices=2"
                ];
                initrd.kernelModules = [
                  "display_connector"
                  "dm_crypt"
                  "dm_mod"
                  "hantro_vpu"
                  "panthor"
                  "phy_rockchip_samsung_hdptx"
                  "phy_rockchip_snps_pcie3"
                  "pinctrl_rk805"
                  "rng_core"
                  "rockchip_rga"
                  "rockchip_rng"
                  "rockchip_vdec"
                  "rockchipdrm"
                  "rocket"
                  "snd_soc_es8316"
                  "snd_soc_audio_graph_card"
                  "synopsys_hdmirx"
                  "spi_rockchip_sfc"
                ];
                loader = lib.mkForce {
                  #systemd-boot.enable = true;
                  efi.canTouchEfiVariables = true;
                  generic-extlinux-compatible.enable = true;
                  grub.enable = false;
                };
                kernelPackages = (kernel.hosts.superlab pkgs "superlab").superlab-kernelPackages;
                #pkgs.ubootRock5ModelB;
                # kernelPackages = kernel.packages;
              };

              zramSwap = {
                enable = true;
                algorithm = "zstd";
                memoryPercent = 20;
                priority = 100;
              };

              hardware = {
                firmware = with self'.packages; lib.singleton armbian-firmware;
                deviceTree.name = "rockchip/rk3588-rock-5b.dtb";
              };
            }
            // (lib.optionalAttrs pkgs.stdenv.buildPlatform.isx86_64 {
              _module.args.pkgs = armPkgs;
            });
        };
      };
    };
  };
}
