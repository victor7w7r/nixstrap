{ kernel, ... }:
{
  kernel.linux = {
    cachyos =
      pkgs:
      with (pkgs.lib.trivial.importJSON ./packages.json).linux;
      pkgs.fetchurl { inherit url sha256; };

    version = pkgs: (kernel.lib.calc-version pkgs (kernel.linux.cachyos pkgs));

    kConfig =
      hardened: pkgs:
      pkgs.stdenvNoCC.mkDerivation {
        name = "cachyos-kconfig";
        phases = [
          "unpackPhase"
          "buildPhase"
          "installPhase"
        ];
        src =
          with (pkgs.lib.trivial.importJSON ./packages.json).kConfig;
          pkgs.fetchFromGitHub {
            inherit
              repo
              rev
              owner
              sha256
              ;
          };

        buildPhase = ''cp "$src/linux-cachyos-${if hardened then "hardened" else "lts"}/config" ./config'';
        installPhase = "cp config $out";
      };
  };
}
