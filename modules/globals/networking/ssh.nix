{ lib, ... }:
{
  den.default = {
    nixos =
      { isPhone, isLive, ... }:
      {
        services.openssh = lib.mkForce {
          enable = true;
          settings = {
            AcceptEnv = null;
            PermitRootLogin = if (isPhone || isLive) then "yes" else lib.mkDefault "prohibit-password";
            PasswordAuthentication = true;
            MaxAuthTries = 3;
            ClientAliveInterval = 300;
            ClientAliveCountMax = 2;
          };
        };
      };
  };
}
