{ buildGoModule, inputs }:
buildGoModule {
  pname = "gspot";
  version = "latest";
  src = inputs.gspot;
  vendorHash = "sha256-HbPPGSL2qfGDYAoyoaPaFK4Urngtc87OWEuHPGtqqYU=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
