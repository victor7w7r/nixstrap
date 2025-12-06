{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      stig
      #https://github.com/smmr-software/mabel
      #uv pip install tewi-transmission
      # https://crates.io/crates/aim
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

  programs.rtorrent.enable = true;
  services.lazysql.enable = true;
  programs.himalaya.enable = true;
  services.pbgopy.enable = true;

}
