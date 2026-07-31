{
  den.aspects.virt.nixos =
    { lib, pkgs, ... }:
    {
      environment = {
        sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
        systemPackages = with pkgs; [ lxcfs ];
        persistence."/nix/persist".directories = lib.mkAfter [
          "/var/lib/lxc"
          "/var/lib/incus"
          "/var/lib/qemu"
        ];
      };

      networking = {
        nftables.enable = true;
        firewall = {
          trustedInterfaces = [ "incusbr0" ];
          interfaces.incusbr0 = {
            allowedTCPPorts = [
              53
              67
            ];
            allowedUDPPorts = [
              53
              67
            ];
          };
        };
      };

      virtualisation.incus = {
        enable = true;
        startTimeout = 300;
        package = pkgs.incus;
        preseed = {
          networks = [
            {
              description = "Default Incus network";
              config = {
                "ipv4.address" = "10.10.10.1/24";
                "ipv4.nat" = "true";
              };
              name = "incusbr0";
              type = "bridge";
            }
          ];
          profiles = [
            {
              description = "Default Incus profile";
              devices = {
                eth0 = {
                  "name" = "eth0";
                  "nictype" = "bridged";
                  "parent" = "incusbr0";
                  "type" = "nic";
                };
                /*
                  root = {
                    "path" = "/";
                    "pool" = "default";
                    "type" = "disk";
                    };
                */
              };
              name = "default";
            }
          ];
          storage_pools = [
            {
              config = {
                size = "4GiB";
                source = "/var/lib/incus/disks/default.img";
              };
              description = "Default Incus storage";
              name = "default";
              driver = "btrfs";
            }
          ];
        };
      };
    };
}
