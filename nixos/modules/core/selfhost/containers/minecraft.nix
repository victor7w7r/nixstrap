{
  lib,
  config,
  ...
}:
let
  inherit (config.services.docker-minecraft-server) modrinth-pack;
  MINECRAFT_VERSION = "1.21.3";
  SERVER_NAME = "v7w7r-mcserver";
  SERVER_NAME_SLUG = lib.strings.toLower (lib.strings.sanitizeDerivationName SERVER_NAME);
  rcon_web_admin_env = "";
in
{
  virtualisation.oci-containers.containers = {
    "rcon-web-admin" = {
      image = "itzg/rcon";
      # https://github.com/rcon-web-admin/rcon-web-admin#environment-variables
      environment = {
        RWA_RCON_HOST = "${SERVER_NAME_SLUG}"; # See docker container `itzg/minecraft-server`: --network-alias=${SERVER_NAME_SLUG}
      };
      environmentFiles = [ rcon_web_admin_env.path ];
      ports = [
        "4326:4326"
        "4327:4327"
      ];
      extraOptions = [
        "--network-alias=rcon-web-admin"
        "--network=${SERVER_NAME_SLUG}_default"
      ];
    };

    "${SERVER_NAME_SLUG}" = {
      image = "itzg/minecraft-server:java21-graalvm";
      environment = rec {
        inherit SERVER_NAME;
        ALLOW_FLIGHT = "TRUE";
        ALLOW_NETHER = "TRUE";
        AUTOPAUSE_TIMEOUT_EST = "3600"; # 1 Hour
        AUTOPAUSE_TIMEOUT_INIT = "600"; # 10 Minutes
        DEBUG = "FALSE";
        DIFFICULTY = "hard";
        ENABLE_AUTOPAUSE = "TRUE";
        EULA = "TRUE";
        LEVEL = "${SERVER_NAME} World 1";
        MAX_PLAYERS = "10";
        MAX_TICK_TIME = "-1";
        MEMORY = "2G";
        HARDCORE = "TRUE";
        ONLINE_MODE = "TRUE";
        OVERRIDE_SERVER_PROPERTIES = "TRUE";
        OP_PERMISSION_LEVEL = "4"; # https://minecraft.fandom.com/wiki/Permission_level#Java_Edition
        SNOOPER_ENABLED = "FALSE";
        SPAWN_ANIMALS = "TRUE";
        SPAWN_NPCS = "TRUE";
        SPAWN_MONSTERS = "TRUE";
        TZ = "America/Guayaquil";
        VERSION = MINECRAFT_VERSION;
        VIEW_DISTANCE = "20";
      };
      environmentFiles = [ rcon_web_admin_env.path ];
      volumes = [
        "/srv/minecraft/${SERVER_NAME_SLUG}-data:/data:rw"
        "${modrinth-pack}:/extras/modrinth-pack/:ro"
      ];
      ports = [ "25565:25565/tcp" ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=${SERVER_NAME_SLUG}"
        "--network=${SERVER_NAME_SLUG}_default"
      ];
    };
  };
}
