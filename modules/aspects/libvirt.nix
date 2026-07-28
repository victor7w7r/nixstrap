{
  den.aspects.libvirt.nixos =
    { lib, pkgs, ... }:
    {
      environment = {
        persistence."/nix/persist".directories = lib.mkAfter [ "/var/lib/libvirt" ];
        systemPackages = with pkgs; [
          bridge-utils
          #nemu # needs QEMU
          netcat-openbsd
          qemu-utils
          usbkvm
          virt-manager
          virt-viewer
          virtio-win
          virtnbdbackup
          win-spice
          winboat
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
