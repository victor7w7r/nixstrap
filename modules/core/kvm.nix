{ pkgs, username, ... }:
{
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    virtio-win
    win-spice
  ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
    containers.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
