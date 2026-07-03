{
  den.aspects.misc.comm.nixos =
    { pkgs, self', ... }:
    {
      environment.systemPackages = with pkgs; [
        self'.packages.carbonyl
        #self'.packages.endcord
        self'.packages.mabel
        discordo
        nchat
        reader
        stig
        #https://github.com/anlar/tewi
      ];
    };
}
