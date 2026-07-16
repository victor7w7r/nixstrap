{ buildGoModule, inputs }:
buildGoModule {
  pname = "goto";
  version = "latest";
  src = inputs.goto;
  vendorHash = "sha256-vED3QySeVRtk0ZeFSXpnQuCThsiNkVW6sNpJbrE8JV4=";
}
