#!/bin/bash

mkdir -p /var/lib/sbctl
sbctl create-keys -e /var/lib/sbctl
sbctl sign -s /boot/EFI/refind/refind_x64.efi
sbctl sign -s /boot/EFI/tools/shellx64.efi
sbctl sign -s /boot/EFI/tools/memtest86.efi
sbctl sign -s /boot/EFI/tools/fwupx64.efi
sbctl sign -s /boot/EFI/refind/drivers_x64/btrfs_x64.efi
sbctl sign -s /boot/EFI/refind/drivers_x64/ext4_x64.efi
sbctl sign -s /boot/EFI/refind/drivers_x64/iso9660_x64.efi