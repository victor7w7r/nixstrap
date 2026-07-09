{ kernel, ... }:
{
  kernel.linux.injector = pkgs: {
    cachyos = kernel.linux.cachyos pkgs;
    version = kernel.linux.version pkgs;
    kConfig = hardened: kernel.linux.kConfig hardened pkgs;
  };
}
