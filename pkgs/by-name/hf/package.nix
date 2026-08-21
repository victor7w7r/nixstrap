{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "hf";
  cargoHash = "sha256-8rKEQVlxeGkvF61dbFmugfPdee7HlWQMFY9IWwBH6xQ=";
  src = inputs.hf;
})
