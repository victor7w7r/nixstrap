{ inputs, ... }:
{
  flake-file.inputs.asus = {
    url = "gitlab:asus-linux/linux-g14/c95c77b20d794c1c962fcccc9735348bdb7d4e76";
    flake = false;
  };

  kernel.patches.asus =
    pkgs:
    (pkgs.stdenvNoCC.mkDerivation {
      name = "asus-patches";
      src = inputs.asus;
      configurePhase = "cp -r $src/* ./";
      buildPhase = ''chmod -R +w . && find . -type f ! -name "*.patch" -delete'';
      installPhase = "mkdir -p $out && cp -r . $out/";
    })
    |> (
      asus:
      map (patch: "${asus}/${patch}.patch") [
        "0001-acpi-proc-idle-skip-dummy-wait"
        "asus-ally-patch-series"
      ]
    );
}
