{
  den,
  inputs,
  kernel,
  ...
}:
{
  den = {
    hosts.x86_64-linux = {
      server-physical-chroot.users.victor7w7r = { };
      server-logical-chroot.users.victor7w7r = { };
      server.users.victor7w7r = { };
    };

    aspects.server =
      { user, ... }:
      {
        includes = with den.aspects; [
          (hosts.lib.static-network "enp1s0" "10")
          server._
          server.containers

          cli._
          dev.mise
          dev.tools
          dev.ccache
          gui._
          misc.comm
          misc.fetch
          pentest._

          cockpit
          kitty
          virt
          secrets
          victor7w7r
        ];

        nixos =
          { config, pkgs, ... }:
          {
            imports = [ inputs.disko.nixosModules.disko ];
            hardware.cpu.intel.updateMicrocode = true;

            # wol -i 192.168.1.255 00:11:22:33:44:55
            # wol aa:bb:cc:dd:ee:ff
            networking = {
              hostName = "v7w7r-youyeetoox1";
              interfaces."enp1s0".wakeOnLan.enable = true;
            };

            virtualisation.incus = {
              ui.enable = true;
              agent.enable = true;
            };

            boot = {
              initrd.services.lvm.enable = true;
              extraModulePackages = [ config.boot.kernelPackages.r8168 ];
              blacklistedKernelModules = [ "r8169" ];
              resumeDevice = "/dev/mapper/swapcrypt";
              kernelParams = [
                "pcie_aspm=off"
                "kvmfr.static_size_mb=128"
              ];
              extraModprobeConfig = ''
                options kvm-intel nested=1
                options kvm_intel emulate_invalid_guest_state=0
              '';
              kernelPackages = (kernel.hosts.server pkgs).server-kernelPackages;
              swraid = {
                enable = true;
                mdadmConf = ''
                  MAILADDR root
                  ARRAY /dev/md/raid0 metadata=1.2 spares=1 UUID=00a19bfc:a0b32154:4ed293e4:28565a8f
                '';
              };
            };

            systemd.tmpfiles.rules = [
              "w /sys/devices/system/cpu/intel_pstate/no_turbo - - - - 1"
            ];

            environment = {
              etc."intel-undervolt.conf".text = "power package 8 28 10 2.4";
              systemPackages = with pkgs; [
                mdadm
                intel-undervolt
                iproute2
                procps
              ];
            };

            zramSwap = {
              enable = true;
              algorithm = "zstd";
              memoryPercent = 100;
              priority = 100;
            };

            services = {
              thermald.enable = true;
              lvm.boot.thin.enable = true;
              rustdesk-server.enable = false;
              tmpfiles.rules = [ "w /sys/block/bcache0/bcache/cache_mode - - - - writethrough" ];
            };

            swapDevices = [
              {
                device = "/dev/mapper/swapcrypt";
                discardPolicy = "both";
                options = [ "nofail" ];
              }
            ];
          };

        provides.to-users.homeManager =
          { config, ... }:
          {
            home.file = {
              "shared".source = config.lib.file.mkOutOfStoreSymlink "/run/media/shared";
              "cloud".source = config.lib.file.mkOutOfStoreSymlink "/nix/persist/cloud";
              ".xinitrc".text = ''
                export XAUTHORITY=/home/${user.name}/.Xauthority
                export XDG_SESSION_TYPE=x11
                export DESKTOP_SESSION=xfce
                exec startxfce4
              '';
            };
          };
      };
  };
}
