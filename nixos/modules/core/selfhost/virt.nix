{ ... }:
{
  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.1.100";
    bridges = [ "br0" ];
  };

  virtualisation.oci-containers.backend = "podman";

  systemd.services = {
    "dhcpcd".enable = false;
    "corosync".enable = false;
    "pvescheduler".enable = false;
    "pvebanner".enable = false;
  };
}
