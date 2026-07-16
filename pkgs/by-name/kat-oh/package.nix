{ buildGoModule, inputs }:
buildGoModule {
  pname = "Kat-OH";
  version = "latest";
  src = inputs.kat-oh;
  vendorHash = "sha256-ArqQ2YPhcb3sRx349ZBsmo4YxxHtgYkh4A4BWZw3aAQ=";
}
