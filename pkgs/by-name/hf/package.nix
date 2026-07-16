{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "hf";
  version = "latest";
  src = inputs.hf;
  cargoHash = "sha256-8rKEQVlxeGkvF61dbFmugfPdee7HlWQMFY9IWwBH6xQ=";
}
