{
  helpers,
  host,
  lib,
  inputs,
  pkgs,
  kernelData,
  hardened ? false,
  ...
}:
let
  configure = pkgs.callPackage ./configure.nix {
    inherit
      hardened
      host
      kernel
      kernelData
      inputs
      helpers
      ;
  };
  kconfigToNix = pkgs.callPackage ./kconfig-to-nix.nix {
    configfile = configure;
  };

  linuxConfigTransfomed =
    if host == "v7w7r-macmini81" then
      import ./config/macminiconfig.x86_64-linux.nix
    else if host == "v7w7r-youyeetoox1" then
      import ./config/serverconfig.x86_64-linux.nix
    else if host == "v7w7r-rc71l" then
      import ./config/rogallyconfig.x86_64-linux.nix
    else
      import ./config/higoleconfig.x86_64-linux.nix;

  kernel =
    (pkgs.linuxManualConfig {
      inherit (configure) src;
      config = linuxConfigTransfomed;
      configfile = configure;
      allowImportFromDerivation = false;
      version = configure.version;
      modDirVersion = lib.versions.pad 3 "${configure.version}${configure.passthru.localVer}";
      stdenv = helpers.stdenvLLVM;

      kernelPatches = builtins.map (file: {
        name = builtins.baseNameOf file;
        patch = file;
      }) configure.passthru.kernelPatches;

      extraMakeFlags = [
        "NIX_ENFORCE_NO_NATIVE=0"
        "NIX_CC_WRAPPER_SUPPRESS_TARGET_WARNING=1"
        "EXTRAVERSION=${configure.localVer}"
        "KCFLAGS=-Wno-error"
      ];
    }).overrideAttrs
      (attrs: {
        passthru = attrs.passthru // {
          inherit kconfigToNix configure;
          modDirVersion = configure.version;
          features = {
            ia32Emulation = true;
            netfilterRPFilter = true;
            efiBootStub = true;
          };
        };
      });
in
{
  inherit kernel;
  packages = pkgs.linuxPackagesFor kernel;
}
