{ kernel, lib, ... }: {
  kernel.lib.package-gen =
    {
      pkgs,
      host,
      cross ? "aarch64-multiplatform",
    }:
    lib.mkMerge [
      (
        (kernel.hosts."${host}" pkgs)
        |> (src: {
          devShells."${host}-kconfig" = kernel.lib.kconfig {
            inherit pkgs;
            kernel = src."${host}-kernel";
          };
          packages = lib.mkAfter {
            "${host}-config" = src."${host}-config";
            "${host}-kernel" = src."${host}-kernel";
          };
        })
      )
      (
        (kernel.hosts."${host}" pkgs.pkgsCross."${cross}")
        |> (src: {
          devShells."${host}-cross-kconfig" = kernel.lib.kconfig {
            pkgs = pkgs.pkgsCross."${cross}";
            kernel = src."${host}-kernel";
          };
          packages = lib.mkAfter {
            "${host}-cross-config" = src."${host}-config";
            "${host}-cross-kernel" = src."${host}-kernel";
          };
        })
      )
    ];
}
