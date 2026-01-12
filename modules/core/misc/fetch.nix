{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
    inputs.batfetch.packages.${pkgs.system}.default
    #inputs.swiftfetch.packages.${pkgs.system}.swiftfetch
    #(pkgs.callPackage ./custom/aerofetch.nix { })
    (pkgs.callPackage ./custom/cargofetch.nix { })
    #(pkgs.callPackage ./custom/customfetch.nix { })
    (pkgs.callPackage ./custom/envfetch.nix { })
    (pkgs.callPackage ./custom/treefetch.nix { })

    #https://github.com/xdearboy/mfetch
    #https://gitlab.com/Maxb0tbeep/bestfetch
    #https://github.com/morr0ne/hwfetch
    #https://github.com/nidnogg/zeitfetch
    #https://github.com/kartavkun/osu-cli
    #https://github.com/ekrlstd/songfetch
    #https://github.com/mustard-parfait/Kat-OH
    #https://github.com/FrenzyExists/frenzch.sh
    #https://github.com/mehedirm6244/sysfex
    #https://github.com/Dr-Noob/gpufetch
    #https://github.com/hexisXz/hexfetch
  ];
}
