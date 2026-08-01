{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "loop";
  src = inputs.loop;
})
