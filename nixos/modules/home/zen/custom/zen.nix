{
  policies,
  system,
  inputs,
}:
/*
  let
    sineUrl = "https://raw.githubusercontent.com/sineorg/bootloader/refs/heads/main/program";
    libNameGlob = "zen-bin-*";
    sineconfig = (
      builtins.fetchurl {
        url = "${sineUrl}/config.js";
        sha256 = "117a6gkaz1kinjflfzqc6qsb4r06x93w08q4lfdzh5a1cng95s5v";
      }
    );
    configpref = (
      builtins.fetchurl {
        url = "${sineUrl}/defaults/pref/config-prefs.js";
        sha256 = "1kkyq5qdp7nnq09ckbd3xgdhsm2q80xjmihgiqbzb3yi778jxzbb";
      }
    );
  in
*/
(inputs.zen-browser.packages.${system}.twilight-unwrapped.override {
  inherit policies;
})
/*
  .overrideAttrs
  (prev: {
    postInstall = (prev.postInstall or "") + ''
      for libdir in "$out"/lib/${libNameGlob}; do
        chmod -R u+w "$libdir"
        cp "${sineconfig}" "$libdir/config.js"
        mkdir -p "$libdir/defaults/pref"
        cp "${configpref}" "$libdir/defaults/pref/config-pref.js"
      done
    '';
    })
*/
