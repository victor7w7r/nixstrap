{
  config,
  host,
  pkgs,
  bootSize ? 256,
  persistSize ? 2048,
  persistLabel ? "persist",
  storeLabel ? "store",
  isHDD ? true,
  populateFirmwareCommands ? "",
  postBuildCommands ? "",
}:
let
  closureInfo = pkgs.buildPackages.closureInfo {
    rootPaths = [ config.system.build.toplevel ];
  };
  imageName =
    "nixos-image-${config.system.nixos.label}-" + "${host}-${pkgs.stdenv.hostPlatform.system}";
  build = pkgs.callPackage ./build.nix {
    inherit
      host
      persistSize
      closureInfo
      persistLabel
      isHDD
      storeLabel
      populateFirmwareCommands
      bootSize
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
        elif [ "$target_fs" == "ext4" ]; then
            ${pkgs.e2fsprogs}/bin/resize2fs "$rootPart" || true
        elif [ "$target_fs" == "bcachefs" ]; then
            ${pkgs.bcachefs-tools}/bin/bcachefs filesystem resize "$mount_point" 1 120G || true
        fi
    }

    set_big "/persist" "f2fs"
    set_big "/nix" "ext4"

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
