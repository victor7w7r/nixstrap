{
  conf,
  lib,
  inputs,
  ...
}:
{
  den.default = {
    os.nixpkgs.config.allowUnfree = true;

    nixos = {
      imports = [ inputs.disko.nixosModules.disko ];

      nix.settings =
        (removeAttrs conf.lib.config.flake-config [ "__provider" ])
        // (removeAttrs conf.lib.config.nix-config [ "__provider" ]);
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
      system.stateVersion = conf.lib.config.stateVersion;
      programs.nix-ld.enable = true;
      documentation = {
        enable = false;
        doc.enable = false;
        info.enable = false;
        man.enable = false;
      };
      #package = lib.mkDefault (pkgs.lix);
    };

    darwin = {
      imports = [ inputs.determinate.darwinModules.default ];
      system = {
        checks.verifyBuildUsers = false;
        stateVersion = 6;
      };
      nix = {
        enable = lib.mkForce false;
        nixPath = lib.mkDefault [ ];
        optimise.automatic = lib.mkDefault false;
      };
      determinateNix.customSettings = {
        flake-registry = "/etc/nix/flake-registry.json";
        sandbox = "relaxed";
      }
      // (removeAttrs conf.lib.config.flake-config [ "__provider" ])
      // (removeAttrs conf.lib.config.nix-config [ "__provider" ]);
    };

  };
}
