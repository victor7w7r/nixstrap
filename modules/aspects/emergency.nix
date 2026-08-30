{
  den.aspects.emergency.nixos =
    { config, pkgs, ... }:
    {
      system.build.emergency-erofs = pkgs.stdenvNoCC.mkDerivation {
        name = "emergency-erofs";

        nativeBuildInputs = with pkgs; [ erofs-utils ];

        buildCommand =
          (pkgs.buildPackages.closureInfo { rootPaths = [ config.system.build.toplevel ]; })
          |> (closureInfo: ''
            mkdir -p rootfs/nix/store

            for path in $(cat ${closureInfo}/store-paths); do
              cp -a "$path" "rootfs/nix/store/"
            done

            mkdir -p rootfs/etc rootfs/var rootfs/proc rootfs/sys rootfs/dev rootfs/tmp rootfs/run
            ln -s ${config.system.build.toplevel}/init rootfs/init

            mkfs.erofs -z zstd,12 -C 65536 -E ztailpacking emergency.erofs rootfs/
            cp emergency.erofs $out
          '');
      };
    };
}
