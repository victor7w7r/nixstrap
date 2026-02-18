{
  lib,
  nix-cachyos-kernel,
  pkgs,
  username,
  ...
}:
let
  params = import ./lib/kernel-params.nix;
  boot = (import ./lib/boot.nix) { };
  btrfs = (import ./lib/btrfs.nix);
  shared = (import ./lib/shared.nix) {
    sharedDir = "/run/media/games";
    partlabel = "games";
  };
  kernel = (import ./kernels/handheld.nix { inherit pkgs nix-cachyos-kernel; });
in
{
  fileSystems = {
    inherit (boot) "/boot" "/boot/emergency";
    inherit (shared) "/run/media/games";
    "/" = btrfs { };
    "/nix" = btrfs { subvol = "nix"; };
    "/nix/persist" = btrfs {
      subvol = "persist";
      depends = [ "/nix" ];
    };
  };

  swapDevices = [ { device = "/dev/vg0/swapcrypt"; } ];
  boot = {
    kernelParams = [
      "amd_iommu=on"
      "amdgpu.sg_display=0"
    ]
    ++ params { };
    kernelPackages = pkgs.linuxPackages_lqx;
    #kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-zen4;
    #kernel.packages;
    initrd = {
      kernelModules = [
        "dm-snapshot"
        "kvm-amd"
        "amdgpu"
      ];
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "thunderbolt"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sdhci_pci"
      ];
      luks.devices.syscrypt = {
        device = "/dev/disk/by-partlabel/disk-main-syscrypt";
        crypttabExtraOpts = [ "tpm2-device=auto" ];
        preLVM = true;
      };
    };
  };

  environment.defaultPackages = [ ];
  environment.systemPackages = with pkgs; [
    alsa-plugins
    alsa-utils
    alsa-firmware
    asusctl
    amdgpu_top
    bluetui
    bluetuith
    kdePackages.plasma-thunderbolt
    pciutils
    powertop
    radeontop
    ryzenadj
    tbtools
    thunderbolt
  ];

  systemd.services = {
    batterThreshold = {
      script = ''
        echo 80 | tee /sys/class/power_supply/BAT0/charge_control_end_threshold
      '';
      wantedBy = [ "multi-user.target" ];
      description = "Set the charge threshold to protect battery life";
      serviceConfig = {
        Restart = "on-failure";
      };
    };
    supergfxd.path = [
      pkgs.kmod
      pkgs.pciutils
    ];
  };

  security.pam.services.ly = {
    name = "ly";
    enable = true;
    startSession = true;
    allowNullPassword = false;
    fprintAuth = true;
  };

  hardware = {
    amdgpu.opencl.enable = true;
    uinput.enable = true;
  };

  programs.rog-control-center.enable = true;

  services = {
    acpid.enable = true;
    auto-cpufreq.enable = true;
    supergfxd = {
      enable = true;
      settings = {
        vfio_enable = true;
        vfio_save = false;
        always_reboot = false;
        no_logind = false;
        logout_timeout_s = 20;
        hotplug_type = "Asus";
      };
    };

    btrfs.autoScrub = {
      enable = true;
      fileSystems = [
        "/nix/persist"
        "/nix"
      ];
      interval = "monthly";
    };

    asusd = {
      enable = true;
      enableUserService = true;
    };
    handheld-daemon = {
      enable = true;
      user = username;
      ui.enable = true;
      adjustor.enable = true;
      adjustor.loadAcpiCallModule = true;
    };
    inputplumber.enable = lib.mkForce false;
    powerstation.enable = false;
    tuned.enable = false;
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="pci", DRIVER=="amdgpu", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/%p/power_dpm_force_performance_level /sys/%p/pp_od_clk_voltage"
      SUBSYSTEM=="usb", ATTR{idVendor}=="2808", ATTR{idProduct}=="a753", MODE="0660", GROUP="input"
    '';
    fprintd = {
      enable = true;
      package = pkgs.fprintd.override {
        libfprint = pkgs.callPackage ./custom/focaltech.nix { };
      };
    };
  };
}
