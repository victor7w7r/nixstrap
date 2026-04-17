{
  isClang ? true,
}:
''
      export CCACHE_COMPRESS=1
      export CCACHE_DIR=/nix/var/cache/ccache-kernel
      export CCACHE_UMASK=007

      ccache_wrap() {
        real_compiler="$1"
        wrapper_path="$2"
        cat > "$wrapper_path" <<EOF
  #!/bin/sh
  for arg in "\$@"; do
    if [ "\$arg" = "-" ]; then
      exec "$real_compiler" "\$@"
    fi
  done
  exec ccache "$real_compiler" "\$@"
  EOF
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
          ccache_wrap "clang++" "$TMPDIR/ccache-wrappers/hostcxx-with-ccache"
        ''
    }
    export makeFlags="CC=$TMPDIR/ccache-wrappers/cc-with-ccache HOSTCC=$TMPDIR/ccache-wrappers/hostcc-with-ccache HOSTCXX=$TMPDIR/ccache-wrappers/hostcxx-with-ccache $makeFlags"
''
