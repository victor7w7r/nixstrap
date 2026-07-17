{ inputs, kernel, ... }:
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

  kernel.linux = {
    version = pkgs: (kernel.lib.calc-version pkgs inputs.cachyos-linux);
    kConfig =
      hardened: pkgs:
      pkgs.stdenvNoCC.mkDerivation {
        name = "cachyos-kconfig";
        phases = [
          "unpackPhase"
          "buildPhase"
          "installPhase"
        ];
        src = inputs.cachyos-config;
        buildPhase = ''cp "$src/linux-cachyos-${if hardened then "hardened" else "lts"}/config" ./config'';
        installPhase = "cp config $out";
      };
  };
}
