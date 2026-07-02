{ lib, ... }:
{
  den.aspects.cli.podman =
    { user, ... }:
    {
      nixos =
        { pkgs, ... }:
        {
          environment = {
            persistence."/nix/persist".users."${user.name}".directories = lib.mkAfter [
              ".local/share/containers"
            ];
            systemPackages = with pkgs; [
              arion
              ctop
              devbox
              distrobox
              distrobox-tui
              dive
              #distrobuilder
              fuse-overlayfs
              oxker
              pods
              podman-tui
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
              zfs
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
