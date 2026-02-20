{ lib, ... }:
{

  nixpkgs.overlays = [
    (self: super: {
      perlPackages = super.perlPackages // {

        MIMEBase32 = super.perlPackages.MIMEBase32.overrideAttrs (oldAttrs: {
          src = super.fetchurl {
            url = "mirror://cpan/authors/id/R/RE/REHSACK/MIME-Base32-1.303.tar.gz";
            hash = "sha256-sET89ToW1bg0UBNf33wNSwwr6ene383z0TPcC3khlzw=";
          };
        });

        MIME-Base64 = super.perlPackages.MIME-Base64.overrideAttrs (oldAttrs: {
          src = super.fetchurl {
            url = "mirror://cpan/authors/id/C/CA/CAPOEIRAB/MIME-Base64-3.16.tar.gz";
            hash = "sha256-9oNRf1bwLzALYZrcjWLbTS0LJ80svmCHSoAIQlDokVA=";
          };
        });

        FindBin = super.perlPackages.FindBin.overrideAttrs (oldAttrs: {
          src = super.fetchurl {
            url = "mirror://cpan/authors/id/T/TO/TODDR/FindBin-1.54.tar.gz";
            hash = "sha256-8IqwsL8DXfNkRAlgfX0vElqPQwZMSRBr5S68DRy+2Zo=";
          };
        });

        Term-ReadLine = super.perlPackages.Term-ReadLine.overrideAttrs (oldAttrs: {
          src = super.fetchurl {
            url = "mirror://cpan/authors/id/F/FL/FLORA/Term-ReadLine-1.14.tar.gz";
            hash = "sha256-c2xHpG8rvuF50JyMUJlw1lYeliVr6VkyPwjzQR6Bves=";
          };
        });

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
