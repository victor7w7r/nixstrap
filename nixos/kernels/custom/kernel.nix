{ lib, fetchurl }:
let
  versionLatest = "6.18.13";
  versionLTS = "6.12.74";
in
{
  inherit versionLatest versionLTS;
  srcLTS = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major versionLTS}.x/linux-${versionLTS}.tar.xz";
    hash = "sha256-0a2UozaBFI7+iE9AKJcNaeMy8rAD8Oi+U6HSXeOOSaI=";
  };
  srcLatest = fetchurl {
    url = "mirror://kernel/linux/kernel/v${lib.versions.major versionLatest}.x/linux-${versionLatest}.tar.xz";
    hash = "sha256-0a2UozaBFI7+iE9AKJcNaeMy8rAD8Oi+U6HSXeOOSaI=";
  };
}
