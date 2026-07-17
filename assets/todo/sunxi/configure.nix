{
  lib,
  pkgs,
  stdenv,
  kernel,
  kernelData,
  ...
}:
let
  majorMinor = lib.versions.majorMinor kernelData.linux.version;
  fetch = (pkgs.callPackage ../fetch.nix { inherit kernelData majorMinor; });
  localVer = "-v7w7r-sunxi-hardened";
  config = (import ./config.nix);
  #modules = ./modules.db;

  isCross = stdenv.hostPlatform != stdenv.buildPlatform;
in

pkgs.stdenv.mkDerivation {
  inherit patches;
  src = fetch.linux;
  name = "linux-${majorMinor}${localVer}-config";

  nativeBuildInputs = kernel.nativeBuildInputs ++ kernel.buildInputs;
  installPhase = "cp .config $out";

  makeFlags = [
    "ARCH=arm64"
  ]
  ++ lib.optionals isCross [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  #prePatch = "${import ./wifi-patch.nix { uwe5622 = fetch.uwe5622; }}";

  /*
      #export LSMOD=$(mktemp)
      #cat "${modules}" | sort > $LSMOD
      #(yes "" | make LSMOD=$LSMOD localmodconfig) || true

      #make ARCH=arm64 $makeFlags olddefconfig
  */

  buildPhase = ''
    export ARCH=arm64
    cp ${fetch.armbian}/config/kernel/linux-sunxi64-current.config .config
    chmod -R +w .config
    make $makeFlags olddefconfig
    patchShebangs scripts/config

    scripts/config ${lib.concatStringsSep " " config}
    make $makeFlags olddefconfig
    cat << 'EOF' >> .config
    CONFIG_UNISOC_WIFI_PS=y
    CONFIG_WLAN_UWE5622=m
    CONFIG_WLAN_UWE5621=m
    CONFIG_TTY_OVERY_SDIO=m
    EOF
  '';

  meta = pkgs.linuxPackages.kernel.passthru.configfile.meta // {
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  passthru = {
    inherit localVer patches;
    version = kernelData.linux.version;
  };
}
