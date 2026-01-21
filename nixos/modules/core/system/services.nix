{ lib, pkgs, ... }:
{
  services = {
    gvfs.enable = true;
    glances.enable = true;
    locate.enable = true;
    #restic.enable = true;
    logrotate.enable = true;
    orca.enable = lib.mkForce false;
    #rustdesk.enable = true;

    dbus = {
      enable = true;
      packages = with pkgs; [
        #nohang
        #uresourced
      ];
    };

    kmscon = {
      enable = true;
      hwRender = false;
      fonts = [
        {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font Mono";
        }
      ];
      extraConfig = ''
        font-size=9
        sb-size=10000
        palette=custom
        palette-background=30, 30, 46
      '';
    };

    timesyncd = {
      enable = false;
      extraConfig = ''
        NTP=time.cloudflare.com
        FallbackNTP=time.google.com 0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
      '';
    };

    irqbalance.enable = true;
    memavaild.enable = true;
    #preload.enable = true;
    prelockd.enable = true;
    resolved.enable = false;
    #uresourced.enable = true;
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
      #desktop = true;
    };

    journald.extraConfig = ''
      Storage=persistent
      Compress=yes
      MaxLevelStore=debug
      SystemMaxUse=500M
      RuntimeMaxUse=200M
      ForwardToConsole=yes
      MaxLevelConsole=debug
      TTYPath=/dev/ttyS0
    '';
  };
}
