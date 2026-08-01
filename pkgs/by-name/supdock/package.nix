{
  crane,
  inputs,
  pkgs,
}:
(crane {
  inherit pkgs;
  pname = "supdock";
  src = inputs.supdock;
})
