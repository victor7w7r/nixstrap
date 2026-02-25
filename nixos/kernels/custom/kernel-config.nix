{
  fetchFromGitHub,
  variant ? "lts",
}:
fetchFromGitHub {
  owner = "CachyOS";
  repo = "linux-cachyos";
  rev = "master";
  sha256 = "sha256-d1GhWEdENpt002r7mmVJ6n4FqJ/W+m8IZJl5ioWDwjo=";
  postFetch = ''
    hold="$(mktemp -d)"
    conf="$hold/conf"
    cp "$out/linux-cachyos-${variant}/config" "$conf"
    rm -rfv "$out"
    cp -v "$conf" "$out"
  '';
}
