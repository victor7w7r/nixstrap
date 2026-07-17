{ disko, ... }:
{
  disko.luks = {
    call =
      {
        name,
        device ? "",
        priority ? null,
        size ? "100%",
        content ? null,
        allowDiscards ? true,
        isForTest ? false,
        entireDisk ? false,
        postCreate ? "",
        postMount ? "",
        keyFile ? "/tmp/key.txt",
      }:
      {
        type = "luks";
        inherit name content;
        postMountHook = postMount;
        settings = { inherit keyFile allowDiscards; };
        preCreateHook = (if isForTest then ''echo -n "test" > /tmp/key.txt'' else "");
        postCreateHook = ''
          cryptsetup config ${device} --label "${name}"
          ${postCreate}
        '';
      }
      |> (content: if entireDisk then content else { inherit size priority content; });

    entire =
      {
        name,
        device,
        postMount ? "",
        postCreate ? "",
        allowDiscards ? false,
      }:
      {
        type = "disk";
        inherit device;
        content = disko.luks.call {
          entireDisk = true;
          size = "100%";
          inherit
            device
            allowDiscards
            name
            postMount
            postCreate
            ;
        };
      };
  };
}
