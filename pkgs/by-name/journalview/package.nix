{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "journalview";
  src = inputs.journalview;
})
