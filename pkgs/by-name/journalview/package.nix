{ inputs, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "journalview";
  version = "main";
  src = inputs.journalview;
  cargoHash = "sha256-OxOfadX+z6KRmnj8e/QVvdSafjlelb2AyIIEpKONChg=";
}
