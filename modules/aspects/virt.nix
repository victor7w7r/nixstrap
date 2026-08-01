{
  den.aspects.virt.nixos =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    {
      #  boot.kernelModules = [ "vhost_vsock" ];
      environment = {
        systemPackages = with pkgs; [
          distrobuilder
          lxcfs
          self'.packages.lxtui
        ];
        persistence."/nix/persist".directories = lib.mkAfter [
          "/var/lib/incus"
          "/var/lib/lxc"
        ];
      };

      virtualisation.incus = {
        enable = true;
        preseed = {
          config = {
            "core.https_address" = ":8443";
            "core.metrics_address" = ":8444";
          };
          networks = [
            {
              config = {
                "ipv4.address" = "10.0.100.1/24";
                "ipv4.nat" = "true";
              };
              name = "incusbr0";
              type = "bridge";
            }
          ];
          profiles = [
            {
              devices = {
                eth0 = {
                  "name" = "eth0";
                  "parent" = "incusbr0";
                  "type" = "nic";
                };
                root = {
                  "path" = "/";
                  "pool" = "default";
                  size = "35GiB";
                  "type" = "disk";
                };
              };
              name = "default";
            }
          ];
          storage_pools = [
            {
              config.source = "/var/lib/incus/storage-pools/default";
              driver = "btrfs";
              name = "default";
            }
          ];
        };
      };
    };
}
