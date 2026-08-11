{ kernel, lib, ... }: {
  kernel.lib.package-gen =
    {
      pkgs,
      host,
      cross ? "aarch64-multiplatform",
    }:
    lib.mkMerge [
      (
        (kernel.hosts."${host}" pkgs false)
        |> (src: {
          devShells."${host}-menu-config" = kernel.lib.menu-config {
            inherit pkgs;
            kernel = src."${host}-kernel";
          };
          packages = lib.mkAfter {
            "${host}-config" = src."${host}-config";
            "${host}-allconfig" = src."${host}-allconfig";
            "${host}-kernel" = src."${host}-kernel";
          };
        })
      )
      /*
        (
        (kernel.hosts."${host}" pkgs.pkgsCross."${cross}" true)
        |> (src: {
          devShells."${host}-cross-menu-config" = kernel.lib.menu-config {
            pkgs = pkgs.pkgsCross."${cross}";
            kernel = src."${host}-kernel";
          };
          packages = lib.mkAfter {
            "${host}-cross-config" = src."${host}-config";
            "${host}-allconfig" = src."${host}-allconfig";
            "${host}-cross-kernel" = src."${host}-kernel";
          };
        })
        )
      */
    ];
}
