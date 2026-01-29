{
  host,
  pkgs,
  username,
  ...
}:
let
  securedDir = ".secured";
  dataDir = ".data";

  vol =
    { dir }:
    ''
      <volume
        user="${username}"
        fstype="fuse"
        path="gocryptfs#/${dir}/%(USER)/${securedDir}"
        mountpoint="/${dir}/%(USER)/${dataDir}"
      />
    '';
in
{
  security.pam = {
    services.login.pamMount = true;
    mount = {
      enable = true;
      additionalSearchPaths = with pkgs; [
        sshfs
        gocryptfs
      ];
      extraVolumes = with pkgs; [
        ''
          <path>${util-linux}/bin:/run/wrappers/bin:${sshfs}/bin:${gocryptfs}/bin</path>
          ${
            if host != "v7w7r-test" then
              ''
                ${vol { dir = "home"; }}
                ${vol { dir = "var"; }}
              ''
            else
              ""
          }
        ''
      ];
      fuseMountOptions = [
        "nodev"
        "nosuid"
        "quiet"
      ];
    };
  };
}
