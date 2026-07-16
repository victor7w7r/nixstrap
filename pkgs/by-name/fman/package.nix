{ buildGoModule, inputs }:
buildGoModule {
  pname = "fman";
  version = "latest";
  src = inputs.fman;
  vendorHash = "sha256-ZfU6KvChsTWu6wGOb9/vq6Bk/AGheZiGNlxh5on3W7Q=";
}
