{ inputs, ... }:
{
  den.default.nixos =
    { lib, ... }:
    {
      nix = {
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };

        optimise = {
          automatic = true;
          dates = [ "weekly" ];
        };
      };

      programs.nh = {
        #clean.enable = true;
        #clean.extraArgs = --keep 10 --keep-since 5d";
        enable = true;
        flake = "github:herobrauni/nix";
        #flake = "/etc/nixos";
      };

      system.autoUpgrade = {
        enable = true;
        # upgrade = false;
        allowReboot = true;
        flake = inputs.self.outPath;
        dates = "04:00";
        randomizedDelaySec = "30min";
        fixedRandomDelay = true;
        flags =
          let
            allInputs = lib.attrNames inputs;
            updateFlags = lib.concatMap (input: [
              "--update-input"
              input
            ]) allInputs;
          in
          updateFlags ++ [ "--commit-lock-file" ];

        rebootWindow = {
          lower = "03:00";
          upper = "05:00";
        };
      };
    };
}
