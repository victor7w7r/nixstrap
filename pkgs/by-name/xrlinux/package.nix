{ cache-stdenv, pkgs }:
let
  arch =
    if pkgs.stdenv.hostPlatform.isx86_64 then
      "x86_64"
    else if pkgs.stdenv.hostPlatform.isAarch64 then
      "aarch64"
    else
      throw "Unsupported architecture for xr-linux-driver";
in
cache-stdenv.mkDerivation (attrs: {
  pname = "xr-linux-driver";
  version = "2.11.7";
  cargoRoot = "modules/xrealInterfaceLibrary/interface_lib/modules/xreal_one_driver";

  cargoDeps = pkgs.rustPlatform.importCargoLock {
    lockFile = "${attrs.src}/${attrs.cargoRoot}/Cargo.lock";
  };

  src = pkgs.fetchFromGitHub {
    owner = "wheaney";
    repo = "XRLinuxDriver";
    rev = "v${attrs.version}";
    hash = "sha256-/KAQ2XgZ5W1ug2DhA93do6PtJLjBv3f5BAAauy9xrT4=";
    fetchSubmodules = true;
    deepClone = true;
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    (python3.withPackages (ps: [ ps.pyyaml ]))
    cargo
    rustc
    rustPlatform.cargoSetupHook
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = with pkgs; [
    libusb1
    libevdev
    openssl
    json_c
    curl
    wayland
    systemd
    stdenv.cc.cc.lib
  ];

  postFetch = ''
    cd $out
    if [ -f .gitmodules ]; then
        substituteInPlace .gitmodules \
        --replace "git@github.com:" "https://github.com/"
    fi
  '';

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'execute_process(COMMAND git submodule update --init --recursive' \
                     'message(STATUS "Skipping git submodule update in Nix build"'

    cat > custom_banner_config.yml <<EOF
    start_date: 0
    end_date: 0
    EOF
  '';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  NIX_LDFLAGS = "-ludev";

  installPhase = ''
    install -Dm755 xrDriver $out/bin/xrDriver

    mkdir -p $out/lib
    for so in $src/lib/${arch}/*.so; do
      [ -f "$so" ] && install -Dm755 "$so" $out/lib/$(basename "$so")
    done
    if [ -d "$src/lib/${arch}/viture" ]; then
      for so in $src/lib/${arch}/viture/*.so*; do
        [ -f "$so" ] && install -Dm755 "$so" $out/lib/$(basename "$so")
      done
    fi

    find . -name 'libhidapi*.so*' \( -type f -o -type l \) | while read -r f; do
      cp -a "$f" $out/lib/
    done

    patchelf --set-rpath "$out/lib:${
      pkgs.lib.makeLibraryPath [
        pkgs.systemd
        pkgs.stdenv.cc.cc.lib
        pkgs.curl
        pkgs.openssl
        pkgs.json_c
        pkgs.libusb1
        pkgs.libevdev
        pkgs.wayland
      ]
    }" $out/bin/xrDriver

    install -Dm755 $src/bin/xr_driver_cli $out/bin/xr_driver_cli
    wrapProgram $out/bin/xr_driver_cli \
      --prefix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.jq
          pkgs.curl
        ]
      }

    install -Dm644 $src/udev/70-xreal-xr.rules $out/lib/udev/rules.d/70-xreal-xr.rules
    install -Dm644 $src/udev/70-uinput-xr.rules $out/lib/udev/rules.d/70-uinput-xr.rules
    install -Dm644 $src/udev/70-rayneo-xr.rules $out/lib/udev/rules.d/70-rayneo-xr.rules
    install -Dm644 $src/udev/70-rokid-xr.rules $out/lib/udev/rules.d/70-rokid-xr.rules
    install -Dm644 $src/udev/70-viture-xr.rules $out/lib/udev/rules.d/70-viture-xr.rules

    install -Dm644 $src/systemd/xr-driver.service $out/lib/systemd/user/xr-driver.service
    substituteInPlace $out/lib/systemd/user/xr-driver.service \
      --replace-fail '{ld_library_path}' "$out/lib" \
      --replace-fail '{bin_dir}' "$out/bin"
  '';

  autoPatchelfIgnoreMissingDeps = [ "libopencv_*" ];
})
