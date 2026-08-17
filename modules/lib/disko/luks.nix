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
        entireDisk ? false,
        postCreate ? "",
        postMount ? "",
        enrollFido2 ? false,
        keyFile ? "/tmp/key.txt",
      }:
      {
        type = "luks";
        inherit name content enrollFido2;
        postMountHook = postMount;
        settings = {
          inherit allowDiscards;
          keyFile = if (!enrollFido2) then keyFile else null;
        };
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
        content ? null,
      }:
      {
        type = "disk";
        inherit device;
        content = disko.luks.call {
          entireDisk = true;
          size = "100%";
          inherit
            name
            device
            content
            allowDiscards
            postMount
            postCreate
            ;
        };
      };
  };
}
