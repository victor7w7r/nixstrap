{
  config,
  ...
}:
{
  age.secrets = {
    passbolt-env = {
      file = ../secrets/passbolt-env-file.age;
    };
  };

  virtualisation.oci-containers.containers.passbolt = {
    image = "passbolt/passbolt";
    dependsOn = [ "pb-mariadb" ];

    environmentFiles = [
      "${config.age.secrets.passbolt-env.path}"
    ];

    volumes = [
      "/nix/persist/containers/passbolt/gpg:/etc/passbolt/gpg"
      "/nix/persist/containers/passbolt/jwt:/etc/passbolt/jwt"
    ];

    environment = {
      DATASOURCES_DEFAULT_PASSWORD = "passbolt";
      DATASOURCES_DEFAULT_HOST = "127.0.0.1";
      DATASOURCES_DEFAULT_USERNAME = "passbolt";
      DATASOURCES_DEFAULT_DATABASE = "passbolt";
      APP_FULL_BASE_URL = "https://passbolt.uwuwhatsthis.de";

      EMAIL_TRANSPORT_DEFAULT_HOST = "mx.uwuwhatsthis.de";
      EMAIL_TRANSPORT_DEFAULT_PORT = "587";
      EMAIL_TRANSPORT_DEFAULT_TLS = "true";
      EMAIL_DEFAULT_FROM = "passbolt@uwuwhatsthis.de";
      EMAIL_TRANSPORT_DEFAULT_USERNAME = "passbolt@uwuwhatsthis.de";
    };

    extraOptions = [
      "--network=container:pb-mariadb"
    ];
  };

  pb-mariadb = {
    image = "mariadb";

    ports = [
      "85:80"
      "445:443"
    ];

    volumes = [
      "/nix/persist/containers/passbolt/mariadb:/var/lib/mysql"
    ];

    environment = {
      MARIADB_USER = "passbolt";
      MARIADB_PASSWORD = "passbolt";
      MARIADB_DATABASE = "passbolt";
      MARIADB_ROOT_PASSWORD = "root";
    };
  };
}
