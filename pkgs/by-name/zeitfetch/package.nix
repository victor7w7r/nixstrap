{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "zeitfetch";
  src = inputs.zeitfetch;
})
