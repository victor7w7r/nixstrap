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
    kvmgt.enable = host != "v7w7r-rc71l" && host != "v7w7r-opizero2w" && host != "v7w7r-fajita";
    podman = {
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
    libvirtd = {
      enable = host != "v7w7r-opizero2w" && host != "v7w7r-fajita";
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
