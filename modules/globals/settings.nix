{ flakelib, inputs, ... }:
{
  _module.args = {
    armPkgs = import inputs.nixpkgs {
      localSystem = "x86_64-linux";
      crossSystem = "aarch64-linux";
    };

    x86Pkgs = import inputs.nixpkgs {
      localSystem = "aarch64-linux";
      crossSystem = "x86_64-linux";
    };
  };

  den.default.nixos = { lib, pkgs, ... }: {
    system.stateVersion = flakelib.lib.config.stateVersion;

    documentation = {
      enable = false;
      doc.enable = false;
      info.enable = false;
      man.enable = false;
    };

    nixpkgs.flake = {
      setNixPath = false;
      setFlakeRegistry = false;
    };

    nix = {
      #package = lib.mkDefault pkgs.lix;
      settings = (flakelib.lib.config.flake-config { }) // (flakelib.lib.config.nix-config { });

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

    programs = {
      nix-ld.enable = true;
      nh = {
        enable = true;
        #clean.enable = true;
        #clean.extraArgs = --keep 10 --keep-since 5d";
        #flake = "github:herobrauni/nix";
        #flake = "/etc/nixos";
      };
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
