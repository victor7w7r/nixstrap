{ inputs, ... }:
{
  flake-file.inputs.asus = {
    url = "gitlab:asus-linux/linux-g14/0e4aca508d46305a4d3fdf814c5d2bded30a2cdb";
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
      map (path: "${asus}/${path}") [
        "0002-platform-x86-asus-armoury-add-keyboard-control-firmw.patch"
        "0040-workaround_hardware_decoding_amdgpu.patch"
        "0070-acpi-x86-s2idle-Add-ability-to-configure-wakeup-by-A.patch"
        "0081-amdgpu-adjust_plane_init_off_by_one.patch"
        "asus-patch-series.patch"
        "PATCH-v5-00-11-Improvements-to-S5-power-consumption.patch"
        "v2-0002-hid-asus-change-the-report_id-used-for-HID-LED-co.patch"
      ]
    );
}
