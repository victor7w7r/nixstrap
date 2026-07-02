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

    provides.to-users.homeManager.programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "ssh.github.com" = {
          hostname = "ssh.github.com";
          user = "git";
          port = 443;
        };
      };
    };
  };
}
