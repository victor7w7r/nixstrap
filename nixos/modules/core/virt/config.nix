{
  host,
  pkgs,
  username,
  ...
}:
{
  virtualisation = {
    waydroid.enable = true;
    spiceUSBRedirection.enable = true;
    kvmgt.enable = host != "v7w7r-rc71l";
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
  };

  users.extraGroups.podman.members = [ username ];

  programs = {
    mdevctl.enable = true;
  };
}
