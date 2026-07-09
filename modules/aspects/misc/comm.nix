{
  den.aspects.misc.comm.nixos =
    { pkgs, self', ... }:
    {
      environment.systemPackages =
        with pkgs;
        with self'.packages;
        [
          carbonyl
          #self'.packages.endcord
          mabel
          discordo
          nchat
          reader
          stig
          #https://github.com/anlar/tewi
        ];
    };
}
