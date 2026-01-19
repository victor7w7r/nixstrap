{ host, ... }:
{
  hardware = {
    ksm.enable = true;
    #sensor.hddtemp.enable = true; SPECIFICATE IN HOSTS with .drives
    bluetooth = {
      enable = (host != "v7w7r-nixvm");
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          FastConnectable = "true";
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
          Experimental = true;
        };
      };
    };
  };

  programs = {
    corectrl.enable = true;
    #corefreq.enable = true;
    iotop.enable = true;
    usbtop.enable = true;
    coolercontrol.enable = true;
  };
}
