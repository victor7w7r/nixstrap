{
  config,
  host,
  pkgs,
  bootSize ? 64,
  persistSize ? 2048,
  persistLabel ? "persist",
  storeLabel ? "store",
  storeFs ? "xfs",
  populateFirmwareCommands ? "",
  populateRootCommands ? "",
  postBuildCommands ? "",
  preBuildCommands ? "",
}:
let
  persist = import ./persist.nix { inherit persistSize persistLabel; };
  boot = import ./boot.nix { inherit bootSize persistSize populateFirmwareCommands; };
  closureInfo = pkgs.buildPackages.closureInfo {
    rootPaths = [ config.system.build.toplevel ];
  };
  store = pkgs.callPackage ./store.nix { inherit storeLabel storeFs closureInfo; };
  imageName =
    "nixos-image-${config.system.nixos.label}-" + "${host}-${pkgs.stdenv.hostPlatform.system}";
  build = pkgs.callPackage ./build.nix {
    inherit
      host
      populateRootCommands
      persist
      preBuildCommands
      boot
      store
      imageName
      postBuildCommands
      ;
  };
in
{
  system.nixos.tags = [ "sd-card" ];
  system.build.image = config.system.build.sdImage;
  system.build.sdImage = build;

  boot.postBootCommands = ''
    set -euo pipefail
    set -x

    set_big() {
      local mount_point=$1
      local target_fs=$2

      local rootPart=$(${pkgs.util-linux}/bin/findmnt -n -o SOURCE "$mount_point" || true)

      if [ -n "$rootPart" ]; then
        if [[ "$rootPart" == /dev/mapper/* ]]; then
          local phys_part="/dev/$(${pkgs.util-linux}/bin/lsblk -npo PKNAME "$rootPart" | head -n1)"
          local is_luks="yes"
        else
          local phys_part="$rootPart"
          local is_luks="no"
        fi

        local bootDevice=$(${pkgs.util-linux}/bin/lsblk -npo PKNAME "$phys_part" | head -n1)

        # Rescatar el número de partición exacto leyendo el sysfs
        local partNum=$(cat /sys/class/block/$(basename "$phys_part")/partition 2>/dev/null || echo "")

        if [ -n "$bootDevice" ] && [ -n "$partNum" ]; then
          echo ",+," | ${pkgs.util-linux}/bin/sfdisk -N$partNum --no-reread "$bootDevice" || true
          ${pkgs.parted}/bin/partprobe "$bootDevice" || true
          sleep 1
        fi

        if [ "$is_luks" == "yes" ]; then
          ${pkgs.cryptsetup}/bin/cryptsetup resize $(basename "$rootPart") || true
        fi

        if [ "$target_fs" == "f2fs" ]; then
          ${pkgs.f2fs-tools}/bin/resize.f2fs "$rootPart" || true
        elif [ "$target_fs" == "xfs" ]; then
          ${pkgs.xfsprogs}/bin/xfs_growfs "$mount_point" || true
        elif [ "$target_fs" == "btrfs" ]; then
          ${pkgs.btrfs-progs}/bin/btrfs filesystem resize max "$mount_point" || true
        fi
      fi
    }

    set_big "/persist" "f2fs"
    set_big "/nix" "xfs"

    if [ -f "/nix/nix-path-registration" ]; then
      REG_FILE="/nix/nix-path-registration"
    elif [ -f "/nix/store/nix-path-registration" ]; then
      REG_FILE="/nix/store/nix-path-registration"
    else
      REG_FILE=""
    fi

    if [ -n "$REG_FILE" ] && [ -f "$REG_FILE" ]; then
      ${config.nix.package.out}/bin/nix-store --load-db < "$REG_FILE"
      touch /etc/NIXOS
      ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      rm -f "$REG_FILE"
    fi
  '';
}
