{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      ariang
      stig
      #https://github.com/smmr-software/mabel
      #uv pip install tewi-transmission
      # https://crates.io/crates/aim
      net-tools
      #https://github.com/Owloops/updo
      # https://github.com/grafviktor/goto
      # https://github.com/qnkhuat/termishare
      # https://github.com/fathyb/carbonyl
      # https://github.com/wynwxst/DisCli
      nchat
      #https://github.com/akinoiro/ssh-list
      # https://github.com/fetchcord/FetchCord
      # https://github.com/sparklost/endcord
      discordo

      reader
      tuicam
    ]
  );

  services.rtorrent.enable = true;
  services.openvpn.package = true;
  services.lazysql.enable = true;
  services.ttyd.enable = true;
  programs.trippy.enable = true;
  programs.himalaya.enable = true;
  programs.bandwhich.enable = true;
  services.pbgopy.enable = true;
  services.tailscale.enable = true;

}
