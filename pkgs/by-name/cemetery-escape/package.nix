{ buildGoModule, inputs }:
buildGoModule {
  pname = "cemetery-escape";
  version = "latest";
  src = inputs.cemetery-escape;
  vendorHash = "sha256-/yOpyvbt+H7AQLXn2gp+6JRaLTDR3hBznOq5L1DUUUQ=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
