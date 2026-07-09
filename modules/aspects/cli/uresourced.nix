{
  den.aspects.cli.uresourced.nixos =
    { self', ... }:
    {
      users = {
        groups.uresourced = { };
        users.uresourced = {
          description = "uresourced service user";
          isSystemUser = true;
          group = "uresourced";
        };
      };
      systemd = {
        packages = with self'.packages; [ uresourced ];
        services.uresourced = {
          enable = true;
          wantedBy = [ "multi-user.target" ];
        };
      };
      environment = {
        systemPackages = with self'.packages; [ uresourced ];
        etc."uresourced.conf".text = ''
          [Global]
          MaxMemoryMin=10%
          #MaxMemoryLow=0


          [ActiveUser]
          MemoryMin=250M
          #MemoryLow=0M
          IOWeight=500
          CPUWeight=500

          [SessionSlice]
          #MemoryMin=250M
          #MemoryLow=0M
          #IOWeight=500
          #CPUWeight=500

          [AppBoost]
          #DefaultCPUWeight=100
          #DefaultIOWeight=100
          ActiveCPUWeight=300
          ActiveIOWeight=300
          BoostCPUWeightInc=200
          BoostIOWeightInc=200
        '';
      };
    };
}
