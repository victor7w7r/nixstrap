{ flake, inputs, ... }:
{
  den.default.nixos = { lib, ... }: {
    nix = {
      #package = lib.mkDefault (pkgs.lix);
      settings =
        (removeAttrs flake.lib.config.flake-config [ "__provider" ])
        // (removeAttrs flake.lib.config.nix-config [ "__provider" ]);

      system.stateVersion = flake.lib.config.stateVersion;

      documentation = {
        enable = false;
        doc.enable = false;
        info.enable = false;
        man.enable = false;
      };

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
        (lib.concatMap (input: [
          "--update-input"
          input
        ]) (lib.attrNames inputs))
        ++ [ "--commit-lock-file" ];

      rebootWindow = {
        lower = "03:00";
        upper = "05:00";
      };
    };
  };
}
