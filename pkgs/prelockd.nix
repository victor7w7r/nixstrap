{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.prelockd;
  confFile = pkgs.writeText "prelockd.conf" ''
    ${cfg.extraConfig}
  '';
  pkg = pkgs.stdenv.mkDerivation rec {
    pname = "prelockd";
    version = "v0.9-de0870e";
    src = pkgs.fetchFromGitHub {
      owner = "hakavlad";
      repo = pname;
      rev = "de0870e";
      sha256 = "sha256-NlDXECD1PPVLXWuhyEEoZH2GOSIKh8feXqPbn89A62o=";
    };

    propagatedBuildInputs = with pkgs; [ python3 ];

    installPhase = ''
      runHook preInstall
      PREFIX= DESTDIR=$out SYSTEMDUNITDIR=/lib/systemd/system SYSCONFDIR=/etc make base units
      substituteInPlace $out/lib/systemd/system/prelockd.service \
        --replace "ExecStart=" "ExecStart=$out"
      runHook postInstall
    '';
  };
in
{
  options.services.prelockd = {
    enable = mkEnableOption (mdDoc "prelockd");

    package = mkOption {
      type = types.package;
      default = pkg;
      description = "Package (derivation) that provides the prelockd binary";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = ''
        $LOCK_PATH_REGEX=/bin/|/sbin/|/usr/|/lib

        $MAX_FILE_SIZE_MIB=50
        $MAX_TOTAL_SIZE_MIB=250
        $MAX_TOTAL_SIZE_PERCENT=5

        $VERBOSITY=1000

        $POLL_INTERVAL_SEC=30

        @LOCK_PATH  MIN_ENTRY=1  FROM_LATEST=3

        $LOCK_ONLY_CRITICAL=True

        @CRITICAL_CGROUP2_REGEX  /user\.slice/user-\d+\.slice/user@\d+\.service.+

        @CRITICAL_NAME_LIST  sh, bash, fish, zsh, sshd, agetty, getty, login
        @CRITICAL_NAME_LIST  systemd, systemd-logind, dbus-daemon, dbus-broker
        @CRITICAL_NAME_LIST  X, Xorg, Xwayland, pulseaudio, pipewire
        @CRITICAL_NAME_LIST  plasmashell, plasma-desktop, kwin_wayland, kwin_x11, kwin, kded4, knotify4, kded5, kdeinit5
        @CRITICAL_NAME_LIST  xfwm4, xfdesktop, xfce4-session, xfsettingsd, xfconfd, xfce4-notifyd, xfce4-screensav, xfce4-panel
        @CRITICAL_NAME_LIST  gala, gala-daemon, notification-da
        @CRITICAL_NAME_LIST  budgie-wm, budgie-daemon, budgie-panel
        @CRITICAL_NAME_LIST  i3, icewm, icewm-session, openbox, fluxbox, awesome, bspwm, sway, wayfire, compiz

        @CRITICAL_NAME_LIST  gnome-terminal-, konsole, xfce4-terminal, mate-terminal, lxterminal, qterminal
        @CRITICAL_NAME_LIST  nautilus, nautilus-deskto, dolphin, pcmanfm-qt, pcmanfm, caja, nemo-desktop, nemo, Thunar
      '';
      description = mdDoc ''
        Extra configuration directives that should be added to
        `prelockd.conf`
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.users.prelockd = {
      description = "prelockd service user";
      isSystemUser = true;
      home = "/var/lib/prelockd";
      createHome = true;
      group = "prelockd";
    };
    users.groups.prelockd = { };
    systemd.packages = [ cfg.package ];
    systemd.services.prelockd.wantedBy = [ "multi-user.target" ];
    systemd.services.prelockd.restartTriggers = [ confFile ];
    environment.etc."prelockd.conf".source = confFile;
  };
}
