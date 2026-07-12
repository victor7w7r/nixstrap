{
  den.aspects.cli.memavalid.nixos =
    { self', ... }:
    ''
      $MIN_MEM_AVAILABLE=2.5%

      $TARGET_MEM_AVAILABLE=3%
      $MAX_CORRECTION_STEP_MIB=50

      $CANCEL_LIMITS_ABOVE_MEM_AVAILABLE=4%
      $CANCEL_LIMITS_IN_TIME=20

      $CANCEL_LIMITS_BELOW_SWAP_FREE_MIB=100

      $MEM_FILL_RATE=4000
      $MAX_INTERVAL=3
      $MIN_INTERVAL=0.2
      $CORRECTION_INTERVAL=0.1

      $VERBOSITY=1

      $MIN_UID=1000
      @LIMIT  CGROUP=system.slice  MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1
      @LIMIT  CGROUP=user.slice    MIN_MEM_HIGH_PERCENT=10  RELATIVE_SHARE=1
    ''
    |> (conf: {
      users = {
        groups.memavaild = { };
        users.memavaild = {
          description = "memavaild service user";
          isSystemUser = true;
          group = "memavaild";
        };
      };
      environment = {
        systemPackages = with self'.packages; [ memavaild ];
        etc."memavaild.conf".text = conf;
      };
      systemd = {
        packages = with self'.packages; [ memavaild ];
        services.memavaild = {
          enable = true;
          wantedBy = [ "multi-user.target" ];
          restartTriggers = [ conf ];
          serviceConfig = {
            ExecStart = "${self'.packages.memavaild}/bin/memavaild";
            User = "memavaild";
          };
        };
      };
    });
}
