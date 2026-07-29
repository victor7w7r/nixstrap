{ lib, ... }: {

  kernel.lib.linux-mod =
    {
      pkgs,
      class ? "",
      dtbMake ? "",
      extra ? "",
    }:
    pkgs.stdenv.mkDerivation {
      name = "linux-mod";
      src =
        (pkgs.linuxKernel.kernels.linux_7_1.override {
          argsOverride = {
            src = pkgs.fetchurl {
              url = "mirror://kernel/linux/kernel/v7.x/linux-7.1.4.tar.xz";
              sha256 = "sha256-HGOSKhGWddOOOuD49u4H8VxBp4arntZlY3SbuMmgji4=";
            };
            version = "7.1.4";
            modDirVersion = "7.1.4";
          };
        }).src;

      postPatch = ''
        ${lib.optionalString (class != "") ''
          find "arch/arm64/boot/dts" -mindepth 1 -maxdepth 1 -type d ! -name "${class}" -exec rm -rf {} +
          cat <<EOF > "$arch/arm64/boot/dts/${class}/Makefile"
              ${dtbMake}
          EOF
        ''}
        ${extra}
      '';
    };
}
