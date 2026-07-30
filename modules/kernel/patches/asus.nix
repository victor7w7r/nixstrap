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
        "0002-platform-x86-asus-armoury-add-keyboard-control-firmw"
        "0040-workaround_hardware_decoding_amdgpu"
        "0070-acpi-x86-s2idle-Add-ability-to-configure-wakeup-by-A"
        "0081-amdgpu-adjust_plane_init_off_by_one"
        "asus-patch-series"
        "PATCH-v5-00-11-Improvements-to-S5-power-consumption"
        "v2-0002-hid-asus-change-the-report_id-used-for-HID-LED-co"
      ]
    );
}
