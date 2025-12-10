{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
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
    ];

}
