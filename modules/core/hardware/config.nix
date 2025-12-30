{ ... }:
{
  hardware = {
    ksm.enable = true;
    #sensor.hddtemp.enable = true; SPECIFICATE IN HOSTS with .drives
  };

  programs = {
    corectrl.enable = true;
    corefreq.enable = true;
    iotop.enable = true;
    usbtop.enable = true;
    coolercontrol.enable = true;
  };
}
