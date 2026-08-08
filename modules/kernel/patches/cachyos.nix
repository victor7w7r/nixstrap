{ inputs, kernel, ... }:
{
  flake-file.inputs.cachyos-patches = {
    url = "github:CachyOS/kernel-patches";
    flake = false;
  };

  kernel.patches.cachyos =
    pkgs:
    "${inputs.cachyos-patches}/${(kernel.lib.version pkgs inputs.linux "").majorMinor}"
    |> (route: {
      bore = map (patch: "${route}/sched-dev/${patch}.patch") [
        #"0001-bore-cachy"
      ];
      std = map (patch: "${route}/misc/${patch}.patch") [
        "0001-aufs-7.1-merge-v20260713"
        "0001-clang-polly"
        "dkms-clang"
      ];
      hardened = map (patch: "${route}/misc/${patch}.patch") [
        #"0001-hardened"
      ];
      handheld = map (patch: "${route}/misc/${patch}.patch") [
        "0001-acpi-call"
        "0001-handheld"
      ];
    });
}

/*
  patches = pkgs.stdenvNoCC.mkDerivation {
    name = "cachyos-patches";
    src = ;
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
          filterdiff -x "${route}" "./${majorMinor}/${routePatch}/${patch}.patch" > ${patch}-filter.patch || true
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
*/
