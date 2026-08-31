{
  den = {
    aspects = {
      snowflake.user = {
        description = "snowflake";
        hashedPassword = "$y$j9T$ieUYJ2thSsvR1M37kWe651$yt0z7Ga3..johS8fyA1Y9GaoddW.jfE838xXiFhcus1";
      };
      root.user = {
        initialHashedPassword = "$y$j9T$ieUYJ2thSsvR1M37kWe651$yt0z7Ga3..johS8fyA1Y9GaoddW.jfE838xXiFhcus1";
      };
      victor7w7r.user =
        { isPhone, ... }:
        {
          description = "victor7w7r";
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGTZ3iQqtjrClKVnqQ0w9Yn2sUoE9lAAW8ZYhR45nV5 arkano036@gmail.com"
          ];
        }
        // (
          if isPhone then
            { initialPassword = "123456"; }
          else
            {
              hashedPassword = "$y$j9T$ieUYJ2thSsvR1M37kWe651$yt0z7Ga3..johS8fyA1Y9GaoddW.jfE838xXiFhcus1";
            }
        );
    };

    default = {
      nixos = { user, ... }: {
        users = {
          groups.i2c = { };
          users."${user.name}".extraGroups = [ "i2c" ];
        };
      };

      provides.to-users.user = {
        linger = true;
        extraGroups = [
          "adbusers"
          "audio"
          "dialout"
          "gamemode"
          "input"
          "kvm"
          "feedbackd"
          "incus-admin"
          "libvirt-qemu"
          "libvirtd"
          "plugdev"
          "power"
          "qemu"
          "qemu-libvirtd"
          "podman"
          "realtime"
          "storage"
          "tty"
          "video"
        ];
      };
    };
  };
}
