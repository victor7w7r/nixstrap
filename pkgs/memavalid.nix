{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.memavaild;
  confFile = pkgs.writeText "memavaild.conf" ''
    ${cfg.extraConfig}
  '';
  pkg = pkgs.stdenv.mkDerivation rec {
    pname = "memavaild";
    version = "v0.5-de0870e";
    src = fetchFromGitHub {
      owner = "hakavlad";
      repo = pname;
      rev = "55352fe";
      sha256 = "sha256-qzEQ8iT4TlOeXv0ihyr7Z+oKfsGXIlkKOURkp9PoYFM=";
    };
    propagatedBuildInputs = with pkgs; [ python3 ];
    installPhase = ''
      runHook preInstall
      PREFIX= DESTDIR=$out SYSTEMDUNITDIR=/lib/systemd/system SYSCONFDIR=/etc make base units
      substituteInPlace $out/lib/systemd/system/memavaild.service \
        --replace "ExecStart=" "ExecStart=$out"
      runHook postInstall
    '';
  };
in
{
  options.services.memavaild = {
    enable = mkEnableOption (mdDoc "memavaild");

    package = mkOption {
      type = types.package;
      default = pkg;
      description = "Package (derivation) that provides the memavaild binary";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = ''
        ## This is memavaild config file.
        ## Lines starting with $ contains required config keys and values.
        ## Lines starting with @ contain optional config keys that may be repeated.
        ## Other lines will be ignored.

        ## condition for starting correction
        $MIN_MEM_AVAILABLE=2.5%

        ## correction step: to what level are we trying to restore available memory
        $TARGET_MEM_AVAILABLE=3%
        $MAX_CORRECTION_STEP_MIB=50

        ## in how many seconds to remove limits if available memory is above the
        ## specified threshold
        $CANCEL_LIMITS_ABOVE_MEM_AVAILABLE=4%
        $CANCEL_LIMITS_IN_TIME=20

        ## remove limits if the free swap volume is below the specified
        $CANCEL_LIMITS_BELOW_SWAP_FREE_MIB=100

        ## monitoring intensity
        $MEM_FILL_RATE=4000
        $MAX_INTERVAL=3
        $MIN_INTERVAL=0.2
        $CORRECTION_INTERVAL=0.1

        $VERBOSITY=1

        $MIN_UID=1000

        @LIMIT  CGROUP=system.slice  MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1

        @LIMIT  CGROUP=user.slice    MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1

        # @LIMIT  CGROUP=user.slice/user-$UID.slice  MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1


        # @LIMIT  CGROUP=user.slice/user-$UID.slice/user@$UID.service/app.slice/app-org.gnome.Terminal.slice  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2

        # @LIMIT  CGROUP=user.slice/user-$UID.slice/user@$UID.service/gnome-terminal-server.service  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2


        # @LIMIT  CGROUP=user.slice/user-$UID.slice/user@$UID.service/idle.slice  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2

        # @LIMIT  CGROUP=idle.slice  MIN_MEM_HIGH_PERCENT=5  RELATIVE_SHARE=0.2

        ## set this in ~/.bashrc
        ## alias idle-run='systemd-run --slice=idle.slice --shell'  # on modern Distros
        ## alias idle-run='systemd-run --setenv=XPWD=$PWD --slice=idle.slice --uid=$UID --gid=$UID -t $SHELL'  # on Debian 9
      '';
      description = mdDoc ''
        Extra configuration directives that should be added to
        `memavaild.conf`
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.users.memavaild = {
      description = "memavaild service user";
      isSystemUser = true;
      group = "memavaild";
    };
    users.groups.memavaild = { };
    systemd.packages = [ pkgs.memavaild ];
    systemd.services.memavaild.wantedBy = [ "multi-user.target" ];
    systemd.services.memavaild.restartTriggers = [ confFile ];
    environment.etc."memavaild.conf".source = confFile;
  };
}
