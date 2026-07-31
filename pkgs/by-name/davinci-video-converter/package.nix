{
  cache-stdenv,
  inputs,
  pkgs,
}:
cache-stdenv.mkDerivation {
  pname = "davinci-video-converter";
  version = "latest";
  src = inputs.davinci-video-converter;
  makeFlags = [ "PREFIX=$(out)" ];

  # nativeBuildInputs = with pkgs; [pkg-config ];
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/local/bin/" "''$out/bin/"
  '';

  preInstall = ''mkdir -p "$out/bin"'';
  buildInputs = with pkgs; [ ffmpeg ];
}
