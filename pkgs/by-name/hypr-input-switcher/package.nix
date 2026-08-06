{ buildGoModule, inputs }:
buildGoModule {
  pname = "hypr-input-switcher";
  version = "main";
  src = inputs.hypr-input-switcher;
  vendorHash = "sha256-/YbDLiXRx6C/Kl8pOEvzFFuXTNroreAOa97FblGs0A8=";
  preBuild = ''export GOCACHE="/var/cache/gocache"'';
  doCheck = false;
  ldflags = [
    "-s"
    "-w"
  ];
  flags = [ "-trimpath" ];
}
