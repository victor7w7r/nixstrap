{
  flake-file.inputs.sdm845-linux = {
    url = "https://codeberg.org/sdm845/linux/archive/25be2fc4eabe9666f78cc3ec80b938fe2d92efea.tar.gz";
    flake = false;
  };

  kernel.linux.sdm845 =
    pkgs:
    with (pkgs.lib.trivial.importJSON ./packages.json).sdm845;
    pkgs.fetchFromGitea {
      inherit
        domain
        owner
        repo
        rev
        hash
        ;
    };
}
