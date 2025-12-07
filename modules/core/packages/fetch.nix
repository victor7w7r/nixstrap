{ pkgs, lib, ... }:
{
  environment.systemPackages =
    with pkgs;
    lib.mkAfter [
      countryfetch
      cpufetch
      freshfetch
      macchina
      microfetch
      nerdfetch
      octofetch
      onefetch
      pfetch-rs
      ramfetch
      uwufetch
      #https://github.com/Toni500github/customfetch
      #https://github.com/ashish-kus/batfetch
      #https://github.com/xdearboy/mfetch
      #https://gitlab.com/Maxb0tbeep/bestfetch
      #https://github.com/driizzyy/AeroFetch
      #https://github.com/ankddev/envfetch
      #https://github.com/morr0ne/hwfetch
      #https://github.com/nidnogg/zeitfetch
      #https://github.com/kartavkun/osu-cli
      #https://github.com/ekrlstd/songfetch
      #https://github.com/Ly-sec/swiftfetch
      #https://github.com/angelofallars/treefetch
      #https://github.com/mustard-parfait/Kat-OH
      #https://github.com/FrenzyExists/frenzch.sh
      #https://github.com/arjav0703/cargofetch
      #https://github.com/mehedirm6244/sysfex
      #https://github.com/Dr-Noob/gpufetch
      #https://github.com/hexisXz/hexfetch
    ];

  programs.fastfetch = {
    enable = true;
  };

}
