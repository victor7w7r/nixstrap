{ pkgs, lib, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      fatrace
      kmon
      lazyjournal
      lnav
      pik
      s-tui
      systemctl-tui
      sysz
      watchexec
      zps
      #iotop-c
      #pcp
      #https://github.com/codervijo/journalview
      #https://github.com/jasonwitty/socktop
      #https://github.com/XhuyZ/lazysys
      #uv pip install tiptop
      #nvtopPackages.intel
    ];

  programs = {
    bottom.enable = true;
    corefreq.enable = true;
    glances.enable = true;
    hwatch.enable = true;
    iotop.enable = true;
    usbtop.enable = true;
  };
}
