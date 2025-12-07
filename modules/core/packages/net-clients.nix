{ pkgs, ... }:
{
  home.packages = (
    with pkgs;
    [
      discordo
      nchat
      reader
      stig
      #https://github.com/smmr-software/mabel
      #uv pip install tewi-transmission
      #https://github.com/Owloops/updo
      #https://github.com/fathyb/carbonyl
      #https://github.com/qnkhuat/termishare
      #https://github.com/wynwxst/DisCli
      #https://github.com/fetchcord/FetchCord
      #https://github.com/sparklost/endcord

      #pkgtop
    ]
  );

  programs = {
    rtorrent.enable = true;
    himalaya.enable = true;
    topgrade.enable = true;
  };
}
