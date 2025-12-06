{
  pkgs,
  lib,
  username,
  rustPlatform,
  fetchFromGitHub,
  ...
}:

let
  lxtui = rustPlatform.buildRustPackage rec {
    pname = "lxtui";
    version = "0.1.1";

    src = fetchFromGitHub {
      owner = "FoleyBridge-Solutions";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-szDsxkkJRYnQ73iemi/DjArO3Z5kIAEoLoPkToHoRtM=";
    };

    cargoSha256 = "0000000000000000000000000000000000000000000000000000";

    buildInputs = [ ];

    meta = with lib; {
      description = "LXD/LXC TUI Manager";
      homepage = "https://github.com/FoleyBridge-Solutions/lxtui";
      license = licenses.mit;
    };
  };
in
{
  programs = {
    looking-glass-client.enable = true;
    mdevctl.enable = true;
    lazydocker.enable = true;
  };

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

  environment.systemPackages = with pkgs; [
    bridge-utils
    ctop
    dialog
    distrobox-tui
    distrobuilder
    dive
    #cockpit-files
    #cockpit-sensors
    #cockpit-machines
    #cockpit-navigator
    #cockpit-podman
    #cockpit-storaged
    fuse-overlayfs
    freerdp
    lxtui
    nemu
    netcat-openbsd
    oxker
    qemu-user
    qemu-utils
    pods
    podman-tui
    usbkvm
    unicorn
    virtnbdbackup
    virt-manager
    virt-viewer
    virtio-win
    x11_ssh_askpass
    waydroid-helper
    win-spice
    yad
  ];
}
