{
  den.aspects.cli.podman =
    { user, ... }:
    {
      nixos =
        {
          lib,
          pkgs,
          self',
          ...
        }:
        {
          environment = {
            persistence."/nix/persist".users."${user.name}".directories = lib.mkAfter [
              ".local/share/containers"
            ];
            systemPackages = with pkgs; [
              arion
              ctop
              container2wasm
              devbox
              distrobox
              dockmate
              distrobox-tui
              dive
              fuse-overlayfs
              gomanagedocker
              kompose
              oxker
              pods
              podman-tui
              self'.packages.dockadvisor
              #self'.packages.dockerfilegraph
              self'.packages.dprs
              self'.packages.supdock
            ];
          };
          virtualisation.podman = {
            enable = true;
            autoPrune.enable = true;
            dockerCompat = true;
            dockerSocket.enable = true;
            defaultNetwork.settings.dns_enabled = true;
            extraPackages = with pkgs; [
              conmon
              crun
              iptables
              nftables
              podman-compose
              podman-tui
              slirp4netns
              skopeo
            ];
          };
        };

      provides.to-users.homeManager =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [ distroshelf ];
          programs.lazydocker.enable = true;
        };
    };
}
