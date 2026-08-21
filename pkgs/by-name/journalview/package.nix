{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "journalview";
  src = inputs.journalview;
  cargoHash = "sha256-OxOfadX+z6KRmnj8e/QVvdSafjlelb2AyIIEpKONChg=";
})
