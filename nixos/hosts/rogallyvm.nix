{ pkgs, username, ... }:
let
  params = import ./lib/kernel-params.nix;

  params = import ./lib/kernel-params.nix;
  boot = (import ./filesystems/boot.nix) { };
  builder =
    {
      subvol ? "",
      isNix ? false,
      depends ? [ ],
    }:
    {
      device = "/dev/vg0/system";
      fsType = "btrfs";
      options = [
        "lazytime"
        "noatime"
        "compress=zstd:1"
        "discard=async"
        "subvol=@${subvol}"
      ]
      ++ (if isNix then [ "noacl" ] else [ ]);
      inherit depends;
      neededForBoot = true;
    };
in
{
  fileSystems = {
    inherit (boot) "/boot/emergency";
    "/" = builder { };
    "/nix" = builder { subvol = "nix"; };
    "/nix/persist" = builder {
      subvol = "persist";
      depends = [ "/nix" ];
    };
  };

  boot = {
    kernelParams = [
      "amd_pstate=active"
      "amd_iommu=on"
    ]
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-deckify-lto;
    ++ params { };
    initrd.luks.devices.syscrypt = {
      device = "/dev/disk/by-partlabel/disk-main-systempv";
      preLVM = true;
    };
  };

  environment.defaultPackages = [ ];
  environment.systemPackages = with pkgs; [
    alsa-plugins
    alsa-utils
    alsa-firmware
    bluetui
    bluetuith
    radeontop
    amdgpu_top
  ];

  systemd.services.supergfxd.path = [ pkgs.pciutils ];

  services.asusd = {
    enable = true;
    enableUserService = true;
  };

}
