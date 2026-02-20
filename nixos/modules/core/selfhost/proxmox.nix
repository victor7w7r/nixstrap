{ lib, ... }:
{

  nixpkgs.overlays = [
    (self: super: {
      perlPackages = super.perlPackages.override {
        overrides = {
          MIMEBase32 = super.perlPackages.MIMEBase32.overrideAttrs (oldAttrs: {
            src = super.fetchurl {
              url = "mirror://cpan/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz";
              hash = "sha256-sET89ToW1bg0UBNf33wNSwwr6ene383z0TPcC3khlzw=";
            };
          });
        };
      };
    })
  ];

  services.proxmox-ve = {
    enable = true;
    ipAddress = "192.168.1.100";
    bridges = [ "vmbr0" ];
  };

  networking.bridges.vmbr0.interfaces = [ "ens18" ];
  networking.interfaces.vmbr0.useDHCP = lib.mkDefault true;
}
