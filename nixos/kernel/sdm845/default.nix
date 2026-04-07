{
  pkgs,
  inputs,
  kernelData,
  ...
}:
let
  mobile-nixos = (import "${inputs.mobile-nixos}/overlay/overlay.nix").mobile-nixos;
  configure = pkgs.callPackage ./configure.nix { inherit kernelData; };
in
mobile-nixos.kernel-builder {
  version = configure.version;
  configfile = configure;
  src = configure.kernel;
  patches = [ ];
  nativeBuildInputs = with pkgs; [
    python3
    zstd
    kmod
  ];

  installTargets = [ "modules_install" ];

  postInstall = ''
    echo ":: Installing Image.gz kernel"
    cp -v "$buildRoot/arch/arm64/boot/Image.gz" "$out/Image.gz"
    ln -sv Image.gz "$out/vmlinuz" || true
    depmod -b "$out" -F "$buildRoot/System.map" "${configure.version}"
  '';

  isModular = true;
  modDirVersion = configure.version;
  isCompressed = "gz";
}
