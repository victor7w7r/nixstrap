{ pkgs }:
pkgs.stdenv.mkDerivation (attrs: {
  pname = "xr-linux-driver";
  version = "2.9.4";

  src = pkgs.fetchgit {
    url = "https://github.com/wheaney/XRLinuxDriver";
    rev = "v${attrs.version}";
    fetchSubmodules = true;
    deepClone = false;
    hash = "sha256-fbaNdv6vjRphYYSzbOYqmRK6c24hv1gkTh3xlql0VEU=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
    (python3.withPackages (ps: [ ps.pyyaml ]))
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    libusb1
    libevdev
    openssl
    json_c
    curl
    wayland
    systemd
    gcc-unwrapped.lib
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-quiet "git submodule update --init --recursive" "true"
    rm -rf modules/xrealInterfaceLibrary/interface_lib/modules/xreal_one_driver

    cat > modules/xrealInterfaceLibrary/interface_lib/src/imu_protocol_xo_stub.c <<'EOF'
    #include "imu_protocol.h"
    static bool xo_open(struct device_imu_t* d, const struct imu_hid_info* i) { (void)d; (void)i; return false; }
    static void xo_close(struct device_imu_t* d) { (void)d; }
    static bool xo_start_stream(struct device_imu_t* d) { (void)d; return false; }
    static bool xo_stop_stream(struct device_imu_t* d) { (void)d; return false; }
    static bool xo_get_static_id(struct device_imu_t* d, uint32_t* o) { (void)d; (void)o; return false; }
    static bool xo_load_cal(struct device_imu_t* d, uint32_t* l, char** o) { (void)d; (void)l; (void)o; return false; }
    static int  xo_next_sample(struct device_imu_t* d, struct imu_sample* o, int t) { (void)d; (void)o; (void)t; return -1; }
    const imu_protocol imu_protocol_xreal_one = {
        .open = xo_open,
        .close = xo_close,
        .start_stream = xo_start_stream,
        .stop_stream = xo_stop_stream,
        .get_static_id = xo_get_static_id,
        .load_calibration_json = xo_load_cal,
        .next_sample = xo_next_sample,
    };
    EOF
    substituteInPlace modules/xrealInterfaceLibrary/interface_lib/CMakeLists.txt \
      --replace-fail \
        "src/hid_ids.c" \
        "src/hid_ids.c src/imu_protocol_xo_stub.c"
  '';

  cmakeFlags = [
    "-DCMAKE_EXE_LINKER_FLAGS=-Wl,--unresolved-symbols=ignore-in-shared-libs"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  hardeningDisable = [
    "fortify"
    "fortify3"
  ];

  installPhase = ''
    install -Dm755 xrDriver "$out/bin/xrDriver"
    install -d "$out/lib"

    cp -P modules/xrealInterfaceLibrary/interface_lib/modules/hidapi/src/linux/libhidapi-hidraw.so* "$out/lib/"
    cp -P modules/xrealInterfaceLibrary/interface_lib/modules/hidapi/src/libusb/libhidapi-libusb.so* "$out/lib/"

    cp -rP ../lib/x86_64/* "$out/lib/"
    install -d "$out/lib/udev/rules.d"
    cp ../udev/*.rules "$out/lib/udev/rules.d/"
    install -d "$out/lib/systemd/user"
    sed \
      -e "s|{ld_library_path}|$out/lib:$out/lib/viture|g" \
      -e "s|{bin_dir}|$out/bin|g" \
      ../systemd/xr-driver.service \
      > "$out/lib/systemd/user/xr-driver.service"
  '';

  postFixup = ''
    wrapProgram "$out/bin/xrDriver" \
      --prefix LD_LIBRARY_PATH : "$out/lib:$out/lib/viture"
  '';

  dontAutoPatchelf = false;
  autoPatchelfIgnoreMissingDeps = [
    "libRayNeoXRMiniSDK.so"
    "libGlassSDK.so"
    "libcarina_vio.so"
    "libglasses.so"
    "libopencv_*.so*"
  ];
})
