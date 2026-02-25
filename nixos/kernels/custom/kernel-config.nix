{
  fetchFromGitHub,
  variant ? "lts",
}:
fetchFromGitHub {
  owner = "CachyOS";
  repo = "linux-cachyos";
  rev = "master";
  sha256 = "sha256-8OyN6x8QYIM1iddi/GGxG4C1OGYcUNSfuwThEXaWHHw=";
  postFetch = ''
    hold="$(mktemp -d)"
    conf="$hold/conf"
    cp "$out/linux-cachyos-${variant}/config" "$conf"
    rm -rfv "$out"
    cp -v "$conf" "$out"
  '';
}
