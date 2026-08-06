{ buildGoModule, inputs }:
buildGoModule {
  pname = "paclear";
  version = "latest";
  src = inputs.paclear;
  vendorHash = "sha256-VE3nnUO3A/HkaoGXef+zuPT2VubWiDfiiSils0F0l74=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
