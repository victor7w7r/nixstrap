{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "hwfetch";
  src = inputs.hwfetch;
})
