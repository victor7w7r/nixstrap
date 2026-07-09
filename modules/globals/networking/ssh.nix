{
  den.default = {
    nixos =
      { lib, ... }@args:
      {
        services.openssh = lib.mkForce {
          enable = true;
          settings = {
            AcceptEnv = null;
            PermitRootLogin =
              if (args.isPhone || args.isLive) then "yes" else lib.mkDefault "prohibit-password";
            PasswordAuthentication = true;
            MaxAuthTries = 3;
            ClientAliveInterval = 300;
            ClientAliveCountMax = 2;
          };
        };
      };
  };
}
