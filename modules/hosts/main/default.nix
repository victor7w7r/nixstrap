{ den, kernel, ... }:
{
  den = {
    hosts.x86_64-linux.main.users.victor7w7r = { };

    aspects.main = {
      includes = with den.aspects; [
        main._

        audio._
        cli._
        dev._
        gui._
        misc.comm
        misc.fetch
        pentest._
        zen._

        android
        bluetooth
        cockpit
        gestures
        kitty
        libvirt
        plasma._
        secrets
        victor7w7r
        waydroid
        xr
      ];
      nixos =
        { pkgs, ... }:
        {
          networking.hostName = "v7w7r-macmini81";

          boot = {
            /*
              extraModulePackages = [
              (pkgs.callPackage ./custom/apple-bce.nix { kernel = kernelBuild.kernel; })
              ];
            */
            kernelPackages = (kernel.hosts.main pkgs).main-kernelPackages;
            #audioT2 = (pkgs.callPackage ./custom/t2-pipewire.nix { });
            resumeDevice = "/dev/mapper/swapcrypt";
          };

          environment.systemPackages = with pkgs; [
            bolt
            tbtools
            thunderbolt
            kdePackages.plasma-thunderbolt
          ];

          services.thermald.enable = true;
          hardware = {
            bolt.enable = true;
            cpu.intel.updateMicrocode = true;
          };

          systemd.tmpfiles.rules = [
            "w /sys/devices/system/cpu/intel_pstate/no_turbo - - - - 1"
            "w /sys/devices/system/cpu/intel_pstate/max_perf_pct - - - - 80"
            "w /sys/block/bcache0/bcache/cache_mode - - - - writethrough"
            "w /sys/block/bcache1/bcache/cache_mode - - - - writethrough"
          ];
        };

      provides.to-users.homeManager =
        { config, ... }:
        {
          programs.looking-glass-client.enable = true;
          home.file = {
            "shared".source = config.lib.file.mkOutOfStoreSymlink "/run/media/shared";
            "storage".source = config.lib.file.mkOutOfStoreSymlink "/nix/persist/storage";
          };
        };
    };
  };
}
