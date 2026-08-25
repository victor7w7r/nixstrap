{
  den,
  hosts,
  inputs,
  kernel,
  ...
}:
{
  perSystem.packages.server-toplevel =
    inputs.self.nixosConfigurations.server.config.system.build.toplevel;

  den = {
    hosts.x86_64-linux = {
      server-physical-chroot.users.victor7w7r = { };
      server-logical-chroot.users.victor7w7r = { };
      server.users = {
        #root = { };
        victor7w7r = { };
      };
    };

    aspects.server =
      { user, ... }:
      {
        includes = with den.aspects; [
          (hosts.lib.static-network "enp1s0" "10")
          (hosts.lib.zram {
            value = "8G";
            memoryPercent = 70;
          })
          server._
          server.containers

          cli._
          dev.mise
          dev.tools
          dev.ccache
          disks
          gui._
          misc.comm
          misc.fetch
          pentest._

          cockpit
          emulation
          firewall
          games
          kitty
          remote
          root
          secrets
          tools
          victor7w7r
          virt
        ];

        nixos =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            hardware.cpu.intel.updateMicrocode = true;

            # wol -i 192.168.1.255 00:11:22:33:44:55
            # wol aa:bb:cc:dd:ee:ff
            networking = {
              hostName = "v7w7r-youyeetoox1";
              #interfaces."enp1s0".wakeOnLan.enable = true;
              nat.externalInterface = "enp1s0";
            };

            virtualisation.incus = {
              ui.enable = true;
              agent.enable = true;
            };

            boot = {
              initrd.services.lvm.enable = true;
              kernelParams = [
                "pcie_aspm=off"
                "kvmfr.static_size_mb=128"
                "iommu=pt"
                "i915.enable_guc=2"
                "kvm_intel.nested=1"
                "intel_pstate=passive"
                "intel_iommu=on"
                "pcie_ports=compat"
                "libahci.ignore_sss=1"
                "ahci.mobile_lpm_policy=2"
                "page_poison=1"
                "oops=panic"
                "randomize_kstack_offset=on"
                "resume=${config.boot.resumeDevice}"
              ];
              extraModprobeConfig = ''
                options kvm-intel nested=1
                options kvm_intel emulate_invalid_guest_state=0
              '';
              kernelPackages =
                (kernel.hosts.server pkgs "server" "x86_64-linux" pkgs.stdenv.hostPlatform.system)
                .server-kernelPackages;
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
              "w /sys/block/bcache0/bcache/cache_mode - - - - writethrough"
            ];

            environment = {
              etc."intel-undervolt.conf".text = "power package 8 28 10 2.4";
              persistence."/nix/persist".directories = lib.mkAfter [ "/var/lib/docker" ];
              systemPackages = with pkgs; [
                mdadm
                intel-undervolt
                iproute2
                picocom
                procps
              ];
            };

            services = {
              thermald.enable = true;
              lvm.boot.thin.enable = true;
              rustdesk-server.enable = false;
            };
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
                exec xfce4-session
              '';
            };
          };
      };
  };
}
