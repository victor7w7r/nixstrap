{ pkgs, ... }:
{
  services = {
    croc.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    gvfs.enable = true;
    locate.enable = true;
    logrotate.enable = true;
    pueue.enable = true;
    sysstat.enable = true;
    tlp.enable = true;
    udisks2.enable = true;

    #opensnitch.enable = true;
    #clamav = {
    #  daemon.enable = true;
    #  updater.enable = true;
    #  scanner.enable = true;
    #};

    dbus = {
      enable = true;
      packages = with pkgs; [
        nohang
        uresourced
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
      enable = true;
      extraConfig = ''
        NTP=time.cloudflare.com
        FallbackNTP=time.google.com 0.arch.pool.ntp.org 1.arch.pool.ntp.org 2.arch.pool.ntp.org 3.arch.pool.ntp.org
      '';
    };
  };
}
