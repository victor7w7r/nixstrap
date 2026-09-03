{ inputs, ... }:
{
  flake-file.inputs = {
    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    macos-kvm = {
      url = "github:Coopydood/ultimate-macOS-KVM";
      flake = false;
    };

    osx-kvm = {
      url = "github:kholia/OSX-KVM";
      flake = false;
    };
  };

  den.aspects.main.vm.nixos = {
    imports = [ inputs.nixvirt.nixosModules.default ];

    boot.extraModprobeConfig = ''
      options kvm-intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options vfio-pci ids=8086:3e9b,8086:a348
      options kvmfr static_size_mb=32
    '';

    virtualisation = {
      kvmgt.enable = true;
      incus.ui.enable = false;
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/libvirt/roms 0755 libvirt-qemu kvm -"
      "d /var/lib/libvirt/images 0755 libvirt-qemu kvm -"

      "C+ /var/lib/libvirt/roms/OVMF_CODE.fd 0644 libvirt-qemu kvm - ${inputs.osx-kvm}/OVMF_CODE.fd"
      "C+ /var/lib/libvirt/roms/Mac_VARS.fd 0644 libvirt-qemu kvm - ${inputs.osx-kvm}/OVMF_VARS-1024x768.fd"
      "C+ /var/lib/libvirt/images/OpenCore.qcow2 0644 libvirt-qemu kvm - ${inputs.osx-kvm}/OpenCore/OpenCore.qcow2"

      "L+ /var/lib/libvirt/roms/i915ovmf.rom - libvirt-qemu kvm - ${inputs.macos-kvm}/ovmf/other/i915ovmf-new.rom"

      "w /sys/bus/pci/devices/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_4/create - - - - 01234567-89ab-4cde-8f01-23456789abcd"
    ];

    security.pam.loginLimits = [
      {
        domain = "@kvm";
        item = "memlock";
        type = "soft";
        value = "unlimited";
      }
      {
        domain = "@kvm";
        item = "memlock";
        type = "hard";
        value = "unlimited";
      }
      {
        domain = "@libvirt";
        item = "memlock";
        type = "soft";
        value = "unlimited";
      }
      {
        domain = "@libvirt";
        item = "memlock";
        type = "hard";
        value = "unlimited";
      }
    ];
  };

}
