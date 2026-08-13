{ inputs, lib, ... }: {
  imports = [ (inputs.den.namespace "kernel" true) ];

  flake-file.inputs =
    { latest = "7.1.8"; lts = "6.18.42"; }
    |> (versions: {
      cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

      linux-cachyos-latest = {
        url = "github:CachyOS/linux/cachyos-${versions.latest}-1";
        flake = false;
      };

      linux-latest = {
        url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major versions.latest}.x/linux-${versions.latest}.tar.xz";
        flake = false;
      };
      
      linux-cachyos-lts = {
        url = "github:CachyOS/linux/cachyos-${versions.lts}-1";
        flake = false;
      };
    });
}
