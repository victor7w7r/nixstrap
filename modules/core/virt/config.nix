{
  pkgs,
  username,
  ...
}:
{
  virtualisation = {
    waydroid.enable = true;
    spiceUSBRedirection.enable = true;
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      extraPackages = with pkgs; [
        podman-compose
        podman-tui
      ];
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    lxc = {
      enable = true;
      lxcfs.enable = true;
      unprivilegedContainers = true;
    };
  };

  users.extraGroups.podman.members = [ username ];
}
