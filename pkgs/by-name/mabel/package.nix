{ buildGoModule, inputs }:
buildGoModule {
  pname = "mabel";
  version = "latest";
  src = inputs.mabel;
  CGO_CFLAGS = "-std=gnu89 -fpermissive";
  vendorHash = "sha256-xWOPiSX2cEmekd2k96O81qn3ygW1nU1MU4qL+JJN0AE=";
}
