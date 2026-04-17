{
  isClang ? true,
}:

let
  wrapperBody = ''
    for arg in "$@"; do
      case "$arg" in
        "-") exec "$real_compiler" "$@" ;;
      esac
    done
    exec ccache "$real_compiler" "$@"
  '';
in
''
  export CCACHE_COMPRESS=1
  export CCACHE_DIR=/nix/var/cache/ccache-kernel
  export CCACHE_UMASK=007

  ccache_wrap() {
    local real_compiler="$1"
    local wrapper_path="$2"
    printf "#!/bin/sh\nreal_compiler='%s'\n%s" "$real_compiler" "${wrapperBody}" > "$wrapper_path"
    chmod +x "$wrapper_path"
  }

  mkdir -p $TMPDIR/ccache-wrappers

  ${
    if isClang then
      ''
        ccache_wrap "clang" "$TMPDIR/ccache-wrappers/cc-with-ccache"
        ccache_wrap "clang" "$TMPDIR/ccache-wrappers/hostcc-with-ccache"
        ccache_wrap "clang++" "$TMPDIR/ccache-wrappers/hostcxx-with-ccache"
      ''
    else
      ''
        ccache_wrap "cc" "$TMPDIR/ccache-wrappers/cc-with-ccache"
        ccache_wrap "cc" "$TMPDIR/ccache-wrappers/hostcc-with-ccache"
        ccache_wrap "c++" "$TMPDIR/ccache-wrappers/hostcxx-with-ccache"
      ''
  }
  export makeFlags="CC=$TMPDIR/ccache-wrappers/cc-with-ccache HOSTCC=$TMPDIR/ccache-wrappers/hostcc-with-ccache HOSTCXX=$TMPDIR/ccache-wrappers/hostcxx-with-ccache $makeFlags"
''
