{
  rustBuild,
  inputs,
  pkgs,
}:
(rustBuild {
  inherit pkgs;
  pname = "dprs";
  cargoHash = "sha256-2NC4N4WZ2ype3MlqlvA/XSOvYkY0lQWlomvAqx11xQ4=";
  src = inputs.dprs;
})
