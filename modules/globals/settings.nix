{ flakelib, inputs, ... }:
{
  den.default.nixos = { lib, ... }: {
    _module.args = {
      armPkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        crossSystem.config = "aarch64-unknown-linux-gnu";
      };
      x86Pkgs = import inputs.nixpkgs {
        system = "aarch64-linux";
        crossSystem.config = "x86_64-unknown-linux-gnu";
      };
    };

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

    system.stateVersion = flakelib.lib.config.stateVersion;
    nix = {
      #package = lib.mkDefault (pkgs.lix);
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
