{ buildGoModule, inputs }:
buildGoModule {
  pname = "updo";
  version = "latest";
  src = inputs.updo;
  vendorHash = "sha256-I5Cu0cXNsPoVBgouE+hRn/s1x2IbRt+V6kHDcfiRIfA=";
  subPackages = [
    "cmd/aws"
    "cmd/monitor"
    "cmd/root"
  ];
}
