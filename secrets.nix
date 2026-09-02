let
  main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOcaIHU3IokpzFxak5YxCtnBQ5t4v7xC9sJagepHlLjZ arkano036@gmail.com";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5DdggFsOQJ2Rh7Q0Gxm73V+QhTmSDeyczASVvrdMn5 arkano036@gmail.com";
  handheld = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqz2UgPIebOs0619u+RNmSkd/QjQpqKUIFW7Sc4UJ6W arkano036@gmail.com";
  pizero = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIHyzkVZbhhBus8yLuLCpJYhnlHl9NVO5/FP3uGWrmYg arkano036@gmail.com";

  user-main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGTZ3iQqtjrClKVnqQ0w9Yn2sUoE9lAAW8ZYhR45nV5 arkano036@gmail.com";
  user-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtujbHCddsta3Oky+aBF8HVBIE6yOPGNss8o5fSrMLe arkano036@gmail.com";
  user-handheld = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXqgBzeyPlT4h+2OGnZobsVj24gyEmgLLqNLAA/D3Qo arkano036@gmail.com";
  user-pizero = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHC82FwfMSTFC4CaNDgJLJeErTfFN6QJ1Lbw1r5H7+6x arkano036@gmail.com";

  keys = [
    main
    server
    handheld
    pizero

    user-main
    user-server
    user-handheld
    user-pizero
  ];
in
{
  #nix run github:ryantm/agenix -- -e test.age
  #nix run github:ryantm/agenix -- -r
  "assets/secrets/seckey-a.age".publicKeys = keys;
  "assets/secrets/seckey-b.age".publicKeys = keys;
  "assets/secrets/seckey-c.age".publicKeys = keys;
  "assets/secrets/seckey-d.age".publicKeys = keys;
  "assets/secrets/yabe.age".publicKeys = keys;

  "modules/hosts/server/secrets/cloudflare-token.age".publicKeys = keys;
  "modules/hosts/server/secrets/copyparty-pass.age".publicKeys = keys;
  "modules/hosts/server/secrets/password-db.age".publicKeys = keys;
  "modules/hosts/server/secrets/seafile-db-env.age".publicKeys = keys;
  "modules/hosts/server/secrets/seafile-env.age".publicKeys = keys;
  "modules/hosts/server/secrets/tailnet.age".publicKeys = keys;
  "modules/hosts/server/secrets/tunnel.age".publicKeys = keys;
}
