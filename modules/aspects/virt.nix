{
  den.aspects.virt.nixos =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    {
      environment = {
        sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
        systemPackages = with pkgs; [
          distrobuilder
          lxcfs
          self'.packahes.lxtui
        ];
        persistence."/nix/persist".directories = lib.mkAfter [
          "/var/lib/incus"
          "/var/lib/lxc"
          "/var/lib/qemu"
        ];
      };

      virtualisation.incus = {
        enable = true;
        preseed = {
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
              driver = "dir";
              name = "default";
            }
          ];
        };
      };
    };
}
