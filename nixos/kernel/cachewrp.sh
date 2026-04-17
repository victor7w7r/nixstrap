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
