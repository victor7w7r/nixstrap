{
  flake-file.inputs.nixpkgs-qemu9.url = "github:NixOS/nixpkgs/fcb54ddcc974cff59bdfb7c1ac9e080299763d2d";

  den.aspects.libvirt.nixos =
    {
      inputs',
      lib,
      pkgs,
      isX86,
      ...
    }:
    {
      systemd.services.libvirtd.environment.QEMU_TCG_THREAD = "multi";

      environment = {
        persistence."/nix/persist".directories = lib.mkAfter [
          "/var/lib/libvirt"
          "/var/lib/qemu"
        ];
        sessionVariables.LIBVIRT_DEFAULT_URI = [ "qemu:///system" ];

        systemPackages =
          with pkgs;
          [
            bridge-utils
            nemu
            netcat-openbsd
            OVMFFull
            qemu-utils
            usbkvm
            virt-manager
            virt-viewer
            virtio-win
            virtnbdbackup
            virglrenderer
            win-spice
            x11_ssh_askpass
          ]
          ++ lib.optional isX86 winboat;
      };

      programs = {
        mdevctl.enable = true;
        virt-manager.enable = true;
      };

      virtualisation = {
        spiceUSBRedirection.enable = true;
        libvirtd = {
          enable = true;
          onBoot = "start";
          qemu = {
            package = inputs'.nixpkgs-qemu9.legacyPackages.qemu_full.override {
              cephSupport = false;
              enableDocs = false;
              xenSupport = false;
              hostCpuTargets = [
                "i386-softmmu"
                "x86_64-softmmu"
                "aarch64-softmmu"
              ];
            };
            verbatimConfig = ''
              user = "victor7w7r"
              group = "users"
              max_queued = 1024
            '';
            runAsRoot = false;
            vhostUserPackages = with pkgs; [ virtiofsd ];
            swtpm.enable = true;
          };

          extraConfig = ''
            unix_sock_group = "libvirtd"
            unix_sock_ro_perms = "0777"
            unix_sock_rw_perms = "0770"
            auth_unix_ro = "none"
            auth_unix_rw = "none"
          '';
        };
      };
    };
}
