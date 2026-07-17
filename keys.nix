let
  main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOcaIHU3IokpzFxak5YxCtnBQ5t4v7xC9sJagepHlLjZ arkano036@gmail.com";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5DdggFsOQJ2Rh7Q0Gxm73V+QhTmSDeyczASVvrdMn5 arkano036@gmail.com";
  handheld = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNkXfjC3QM0xSle1LkxySgKg/ddsN6YAcp/5Lufo1v4 arkano036@gmail.com";
  pizero = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAn3nBXA6K2kTnTMSk5/Fhl2TgCCffWybPqpol/8mc1P arkano036@gmail.com";

  user-main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGTZ3iQqtjrClKVnqQ0w9Yn2sUoE9lAAW8ZYhR45nV5 arkano036@gmail.com";
  user-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOtujbHCddsta3Oky+aBF8HVBIE6yOPGNss8o5fSrMLe arkano036@gmail.com";
  user-handheld = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXqgBzeyPlT4h+2OGnZobsVj24gyEmgLLqNLAA/D3Qo arkano036@gmail.com";
  user-pizero = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDtH26q1AfO+AHd84H9L+a8FB28xfMIJLJgsCjgYWebi arkano036@gmail.com";

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
  #nix run github:ryantm/agenix -- -e ...
  "assets/secrets/seckey-a.age".publicKeys = keys;
  "assets/secrets/seckey-b.age".publicKeys = keys;
  "assets/secrets/seckey-c.age".publicKeys = keys;
  "assets/secrets/seckey-d.age".publicKeys = keys;
  "modules/hosts/server/secrets/cloudflare-token.age".publicKeys = keys;
  "modules/hosts/server/secrets/password-db.age".publicKeys = keys;
  "modules/hosts/server/secrets/seafile-db-env.age".publicKeys = keys;
  "modules/hosts/server/secrets/seafile-env.age".publicKeys = keys;
  "modules/hosts/server/secrets/tailnet.age".publicKeys = keys;
  "modules/hosts/server/secrets/tunnel.age".publicKeys = keys;
}
