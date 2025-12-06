{ pkgs, ... }:

{
  home.packages = (
    with pkgs;
    [
      pik
      zps
      gnuplot
      systemctl-tui
      sysz
      #https://github.com/XhuyZ/lazysys
      lazyssh
      lazyjournal
      fatrace
      #uv pip install tiptop
      #nvtopPackages.intel
      s-tui
      kmon
      i2c-tools
      read-edid
      hwinfo
      #https://github.com/jasonwitty/socktop
      fan2go
      ddrescue
      ddrutility
      testdisk
      scrounge-ntfs
      ext4magic
      myrescue
      extundelete
      #https://github.com/ashish-kus/batfetch
      #https://aur.archlinux.org/packages/r-linux
      #https://github.com/davispuh/btrfs-data-recovery
      magicrescue
      safecopy
      foremost

      gptfdisk
      dysk
      tparted
      httm
      compsize
      #https://aur.archlinux.org/packages/chkufsd-bin
      wiper
      cshatag
      wipefreespace
      ntfs2btrfs
      #https://github.com/ximion/btrfsd
      #https://github.com/nachoparker/btrfs-du
      #https://github.com/benapetr/compress
      partclone
      fsarchiver
      #https://github.com/gdelugre/ext4-crypt
      #https://aur.archlinux.org/packages/ntfs3-dkms-git
      #https://aur.archlinux.org/packages/udefrag

      cpufetch
      #https://github.com/ashish-kus/batfetch
      onefetch
      #https://github.com/driizzyy/AeroFetch
      macchina
      freshfetch
      pfetch-rs
      ramfetch
      #https://github.com/xdearboy/mfetch
      microfetch
      #https://gitlab.com/Maxb0tbeep/bestfetch
      countryfetch
      #https://github.com/Toni500github/customfetch
      # https://github.com/ankddev/envfetch
      # https://github.com/morr0ne/hwfetch
      nerdfetch
      #https://github.com/nidnogg/zeitfetch
      uwufetch
      octofetch
      #https://github.com/kartavkun/osu-cli
      # https://github.com/ekrlstd/songfetch
      # https://github.com/Ly-sec/swiftfetch
      # https://github.com/angelofallars/treefetch
      # https://github.com/arjav0703/cargofetch
      # https://github.com/mehedirm6244/sysfex
      # https://github.com/Dr-Noob/gpufetch
      # https://github.com/hexisXz/hexfetch
      # https://github.com/FrenzyExists/frenzch.sh
      # https://github.com/mustard-parfait/Kat-OH
    ]
  );

  programs.fastfetch.enable = true;
  programs.bottom.enable = true;
  programs.corefreq.enable = true;
  programs.usbtop.enable = true;
  programs.iotop.enable = true; # iotop-c
  services.glances.enable = true;
  services.sysstat.enable = true;
  hardware.sensor.hddtemp.enable = true;
}
