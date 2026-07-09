{
  den.aspects.libvirt.nixos =
    { lib, pkgs, ... }:
    {
      environment = {
        sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];
        persistence."/nix/persist".directories = lib.mkAfter [
          "/var/lib/libvirt"
          "/var/lib/lxc"
          "/var/lib/qemu"
        ];
        systemPackages = with pkgs; [
          bridge-utils
          dialog
          freerdp
          nemu
          netcat-openbsd
          qemu-utils
          usbkvm
          virt-manager
          virt-viewer
          virtio-win
          virtnbdbackup
          win-spice
          yad
          x11_ssh_askpass
        ];
      };

      programs = {
        mdevctl.enable = true;
        virt-manager.enable = true;
      };

      virtualisation = {
        spiceUSBRedirection.enable = true;
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            vhostUserPackages = with pkgs; [ virtiofsd ];
            swtpm.enable = true;
          };
        };
      };
    };
}
