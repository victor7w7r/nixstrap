{
  pkgs,
  lib,
  host,
  system,
  ...
}:
let
  audioT2 = (pkgs.callPackage ./custom/t2-pipewire.nix { });
  power-script =
    let
      policyFile = "/sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference";
      hwpFile = "/sys/devices/system/cpu/cpufreq/policy*/hwp_dynamic_boost";

      hwp = if host == "v7w7r-higole" then "0" else "1";
      acProfile = if host == "v7w7r-higole" then "balanced" else "performance";
      batteryProfile = if host == "v7w7r-higole" then "power-saver" else "balanced";

      acPolicy = if host == "v7w7r-higole" then "performance" else "power";
      batteryPolicy = if host == "v7w7r-higole" then "power" else "balance_power";
    in
    pkgs.writeShellScript "power-script" ''
       STATE=$(cat /sys/class/power_supply/AC*/online 2>/dev/null || echo 1)

       if [ "$STATE" = "1" ]; then
         echo "${acPolicy}" > ${policyFile}
         echo ${hwp} > ${hwpFile}
         ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set ${acProfile}
       else
      echo "${batteryPolicy}" > ${policyFile}
         echo 0 > ${hwpFile}
         ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set ${batteryProfile}
       fi
    '';
in
{
  services = {
    blueman.enable = host != "v7w7r-nixvm";
    fwupd.enable = host != "v7w7r-macmini81" && host != "v7w7r-nixvm";
    #lact.enable = true;
    smartd.enable = false;
    #upower.enable = lib.mkDefault host != "v7w7r-youyeetoox1" && host != "v7w7r-macmini81";
    power-profiles-daemon.enable = true;
    thermald.enable = host != "v7w7r-vm" && host != "v7w7r-rc71l" && system != "aarch64-linux";
    udev.extraRules = ''
      SUBSYSTEM=="power_supply", ACTION=="change", RUN+="${power-script}"
    '';
    pipewire = {
      enable = (
        host == "v7w7r-macmini81"
        || host == "v7w7r-higole"
        || host == "v7w7r-rc71l"
        || host == "v7w7r-fajita"
      );
      package = lib.mkForce (
        if host == "v7w7r-macmini81" then audioT2.pipewirePackage else pkgs.pipewire
      );
      extraConfig.pipewire = {
        "10-clock-quantum"."context.properties"."default.clock.min-quantum" = 1024;
        "99-allowed-rates"."context.properties"."default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
      };
      alsa = {
        enable = true;
        #support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      socketActivation = true;
      wireplumber = {
        enable = (host == "v7w7r-macmini81" || host == "v7w7r-higole" || host == "v7w7r-rc71l");
        package = lib.mkForce (
          pkgs.wireplumber.override {
            pipewire = audioT2.pipewirePackage;
          }
        );
      };
    };
  };

  systemd.services = {
    /*
      systemd.sleep.settings.Sleep = {
        HibernateDelaySec = "1h";
        SuspendState = "mem";
      };
    */

    power-setup-ac-battery = {
      description = "Setup Energy Profile";
      enable = false;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${power-script}";
      };
    };
    cpu-boost-control = {
      enable = host != "v7w7r-rc71l";
      description = "Turbo Boost Management";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c 'echo ${
          if host == "v7w7r-youyeetoox1" then "0" else "1"
        } > /sys/devices/system/cpu/intel_pstate/no_turbo'";
      };
    };
    limit-cpu-perf = {
      description = "Limit CPU";
      enable = host != "v7w7r-rc71l" && host != "v7w7r-youyeetoox1";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart =
          let
            is-mac = host == "v7w7r-macmini81" || host == "v7w7r-higole";
            value = if is-mac then "80" else "70";
          in
          "${pkgs.bash}/bin/bash -c 'echo ${value} > /sys/devices/system/cpu/intel_pstate/max_perf_pct'";
        RemainAfterExit = true;
      };
    };
    t2fanrd = {
      enable = host == "v7w7r-macmini81";
      description = "T2FanRD daemon to manage fan curves for T2 Macs";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "exec";
        ExecStart = "${(pkgs.callPackage ./custom/t2fanrd.nix { })}/bin/t2fanrd";
        Restart = "always";

        PrivateTmp = true;
        ProtectSystem = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectProc = "invisible";
        PrivateDevices = true;
        PrivateNetwork = true;
        NoNewPrivileges = true;
        DevicePolicy = "closed";
        KeyringMode = "private";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
      };
    };

    "apple-bce-reload" = {
      enable = host == "v7w7r-macmini81";
      description = "Disable and Re-Enable Apple BCE Module";
      wantedBy = [ "sleep.target" ];
      before = [ "sleep.target" ];
      unitConfig.StopWhenUnneeded = true;

      serviceConfig = {
        User = "root";
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStart = [
          "${pkgs.kmod}/bin/modprobe -r brcmfmac_wcc"
          "${pkgs.kmod}/bin/modprobe -r brcmfmac"
          "${pkgs.kmod}/bin/rmmod -f apple_bce"
        ];

        ExecStop = [
          "${pkgs.kmod}/bin/modprobe apple_bce"
          "${pkgs.kmod}/bin/modprobe brcmfmac"
          "${pkgs.kmod}/bin/modprobe brcmfmac_wcc"
        ];
      };
    };
  };
}
