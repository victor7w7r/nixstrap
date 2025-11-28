{ pkgs, username, ... }:
{
  users.users.${username}.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    win-virtio
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