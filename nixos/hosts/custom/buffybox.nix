{
  pkgs,
  stdenv,
  fetchFromGitLab,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "buffyboard";
  version = "3.3.0-unstable-2025-06-12";
  src = fetchFromGitLab {
    domain = "gitlab.postmarketos.org";
    owner = "postmarketOS";
    repo = "buffybox";
    fetchSubmodules = true;
    rev = "dd30685f75f396ba9798e765c798342a5ea47370";
    hash = "sha256-l9bIcn5UkpAI6Z6W4rjj20lEAhJn+5GPaiGOVEtENhA=";
  };

  depsBuildBuild = with pkgs; [ pkg-config ];

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = with pkgs; [
    inih
    libdrm
    libinput
    libxkbcommon
  ];

  mesonInstallTags = [ "buffyboard" ];
  env.PKG_CONFIG_SYSTEMD_SYSTEMD_SYSTEM_UNIT_DIR = "${placeholder "out"}/lib/systemd/system";

  strictDeps = true;
})
