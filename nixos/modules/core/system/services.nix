{
  system,
  host,
  lib,
  pkgs,
  ...
}:
{
  services = {
    gvfs.enable = true;
    glances.enable = false;
    locate.enable = true;
    lvm.boot.thin.enable = true;
    #restic.enable = true;
    logrotate.enable = true;
    orca.enable = lib.mkForce false;
    #rustdesk.enable = true;

    dbus = {
      enable = true;
      packages = [
        #nohang
        #uresourced
      ];
    };

    kmscon = {
      enable = host != "v7w7r-youyeetoox1" && host != "v7w7r-opizero2w" && host != "v7w7r-fajita";
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

    irqbalance.enable = true;
    memavaild.enable = true;
    chrony.enable = true;
    #preload.enable = true;
    prelockd.enable = host != "v7w7r-youyeetoox1";
    resolved.enable = false;
    #uresourced.enable = true;
    scx.enable = system != "aarch64-linux";

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

    /*
      nohang = {
      enable = true;
      #desktop = true;
      };
    */

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
