{ inputs, ... }:
{
  flake-file.inputs = {
    cachyos-linux = {
      url = "github:CachyOS/linux/cachyos-6.18.38-1";
      flake = false;
    };
    cachyos-config = {
      url = "github:CachyOS/linux-cachyos";
      flake = false;
    };
  };

  kernel.lib = {
    cachyos-config =
      pkgs: isHardened:
      pkgs.stdenvNoCC.mkDerivation {
        name = "cachyos-kconfig";
        phases = [
          "unpackPhase"
          "buildPhase"
          "installPhase"
        ];
        src = inputs.cachyos-config;
        buildPhase = ''cp "$src/linux-cachyos-${
          if isHardened then "hardened" else "lts"
        }/config" ./config'';
        installPhase = "cp config $out";
      };

    filtered-config =
      pkgs: configfile:
      pkgs.stdenvNoCC.mkDerivation {
        name = "filtered-config";
        src = configfile;
        phases = [ "installPhase" ];
        installPhase = ''
          cp $src .config
          sed -i '/^[[:space:]]*#/d; /^[[:space:]]*$/d' .config
          sed -i -E 's/[[:space:]]+"\s*$/"/' .config
          mv .config $out
        '';
      };
  };

}
