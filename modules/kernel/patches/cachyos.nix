{ inputs, kernel, ... }:
{
  flake-file.inputs.cachyos-patches = {
    url = "github:CachyOS/kernel-patches";
    flake = false;
  };

  kernel.patches.cachyos =
    pkgs:
    let
      majorMinor = (kernel.lib.version pkgs inputs.linux "").majorMinor;
      patches = pkgs.stdenvNoCC.mkDerivation {
        name = "cachyos-patches";
        src = inputs.cachyos-patches;
        phases = [
          "unpackPhase"
          "buildPhase"
          "installPhase"
        ];

        nativeBuildInputs = with pkgs; [
          findutils
          patchutils
        ];

        configurePhase = "cp -r $src/* ./";
        buildPhase =
          let
            differ = route: routePatch: patch: ''
              filterdiff -x "*/${route}" "./${majorMinor}/${routePatch}/${patch}.patch" > ${patch}-filter.patch || true
              cat ${patch}-filter.patch > "./${majorMinor}/${routePatch}/${patch}.patch" || true
            '';
          in
          ''
            chmod -R +w . && find . -type d -empty -delete
            #${differ "drivers/input/joystick/xpad.c" "misc" "0001-handheld"}
            #${differ "security/selinux/selinuxfs.c" "misc" "0001-hardened"}
          '';
        installPhase = "mkdir -p $out && cp -r . $out/";
      };
      bore = [
        # "${patches}/${majorMinor}/sched-dev/0001-bore-cachy.patch"
      ];
      opt = map (patch: "${patches}/${majorMinor}/misc/${patch}.patch") [
        "0001-aufs-7.1-merge-v20260713"
        "0001-clang-polly"
        "dkms-clang"
      ];
    in
    {
      inherit bore opt;
      std = opt ++ bore;
      hardened = opt; # ++ map (path: "${patches}/${majorMinor}/misc/${path}") [ "0001-hardened.patch" ];
      handheld =
        bore
        ++ opt
        ++ map (patch: "${patches}/${majorMinor}/misc/${patch}.patch") [
          "0001-acpi-call"
          "0001-handheld"
        ];
    };
}
