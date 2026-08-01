{ cache-stdenv, pkgs }:
cache-stdenv.mkDerivation (attrs: {
  pname = "zig-waybar-contrib";
  version = "0.17.x";
  src = pkgs.fetchFromGitea {
    domain = "codeberg.org";
    owner = "erffy";
    repo = attrs.pname;
    rev = attrs.version;
    sha256 = "sha256-RFfynyADrukAyr+QpdlMDLl7R1XQUmB6mlTBYeW8xso=";
  };

  nativeBuildInputs = with pkgs; [ zig_0_12.hook ];
  zigBuildFlags = [ "-Drelease-safe=true" ];

  postPatch = ''
    cat << 'EOF' > build.zig.zon
    .{
        .name = "zig-waybar-contrib",
        .version = "1.0.0",
        .paths = .{
            "build.zig",
            "src",
        },
    }
    EOF
  '';

  postInstall = ''
    mkdir -p $out/share/zig-waybar-contrib
    sed -i "s|{{EXECUTABLE_PATH}}|$out/bin|g" config.waybar.jsonc
    cp config.waybar.jsonc $out/share/zig-waybar-contrib/config.jsonc
  '';
})
