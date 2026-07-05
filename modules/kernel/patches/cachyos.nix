{
  kernel.patches.cachyos =
    pkgs: majorMinor:
    let
      patches = pkgs.stdenvNoCC.mkDerivation {
        name = "cachyos-patches";
        src =
          with (pkgs.lib.trivial.importJSON ./patches.json).cachyos;
          pkgs.fetchFromGitHub {
            inherit
              repo
              rev
              owner
              sha256
              ;
          };

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
            ${differ "drivers/input/joystick/xpad.c" "misc" "0001-handheld"}
            ${differ "security/selinux/selinuxfs.c" "misc" "0001-hardened"}
          '';
        installPhase = "mkdir -p $out && cp -r . $out/";
      };
      bore = [ "${patches}/${majorMinor}/sched-dev/0001-bore-cachy.patch" ];
      optimization = map (path: "${patches}/${majorMinor}/misc/${path}") [
        "0001-clang-polly.patch"
        "dkms-clang.patch"
        "poc-selector.patch"
      ];
      governors = map (path: "${patches}/${majorMinor}/misc/${path}") [
        #"reflex-governor.patch"
        "nap-governor.patch"
      ];
    in
    {
      inherit bore optimization governors;
      common = bore ++ optimization ++ governors;
      hardened = map (path: "${patches}/${majorMinor}/misc/${path}") [ "0001-hardened.patch" ];
      handheld = map (path: "${patches}/${majorMinor}/misc/${path}") [
        "0001-acpi-call.patch"
        "0001-handheld.patch"
      ];
    };
}
