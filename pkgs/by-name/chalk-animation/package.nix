{ buildNpmPackage, inputs }:
buildNpmPackage {
  pname = "chalk-animation";
  version = "latest";
  src = inputs.chalk-animation;
  dontNpmBuild = true;
  npmDepsHash = "sha256-7kIH6e4cbp6Uw1JJmHXhgS9IBW9LzkEBdKEEiRDOYvQ=";
  postInstall = "mkdir -p $out/bin && chmod +x $out/bin/chalk-animation";
}
