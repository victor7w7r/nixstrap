{
  fetchFromGitHub,
  fetchgit,
  ...
}:
{
  cachy = fetchFromGitHub {
    owner = "CachyOS";
    repo = "kernel-patches";
    rev = "master";
    sha256 = "sha256-LhKeRpbG355d/h0H+esisnZ695I7PTFjEkOHKeEtO54=";
    postFetch = ''
      find "$out" -type f \
        ! -path "*/sched/0001-bore-cachy.patch" \
        ! -path "*/misc/0001-hardened.patch" \
        ! -path "*/misc/0001-acpi-call.patch" \
        ! -path "*/misc/0001-handheld.patch" \
        ! -name "0001-amd-pstate.patch" \
        ! -name "0002-asus.patch" \
        ! -name "0008-intel-pstate.patch" \
        ! -name "0001-cachyos-base-all.patch" \
        ! -name "0009-sched-ext.patch" \
        ! -name "0010-t2.patch" -delete
      find "$out" -type d -empty -delete
    '';
  };

  asus = fetchgit {
    url = "https://gitlab.com/asus-linux/linux-g14";
    rev = "0e4aca508d46305a4d3fdf814c5d2bded30a2cdb";
    sha256 = "sha256-3G/oLfYdL+g+OoacjOuEwFg7/EyLPxKCnlZfHOYWmTk=";
    postFetch = ''find "$out" -type f ! -name "*.patch" -delete'';
  };

}
