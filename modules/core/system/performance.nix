{ pkgs, ... }:
{
  services = {
    irqbalance.enable = true;
    memavaild.enable = true;
    #preload.enable = true;
    prelockd.enable = true;
    resolved.enable = false;
    uresourced.enable = true;
    scx.enable = true;

    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
      extraRules = [
        {
          "name" = "gamescope";
          "nice" = -20;
        }
      ];
    };

    nohang = {
      enable = true;
      desktop = true;
    };

    journald.extraConfig = ''
      Storage=persistent
      Compress=yes
      MaxLevelStore=debug
      SystemMaxUse=500M
      RuntimeMaxUse=200M
      ForwardToConsole=yes
      MaxLevelConsole=debug
      TTYPath=/dev/tty12
    '';
  };
}
