{ pkgs, ... }:
{
  environment.systemPackages = [
    (pkgs.runCommand "ugm"
      {
        nativeBuildInputs = [
          pkgs.eget
          pkgs.cacert
        ];
      }
      ''
        mkdir -p $out/bin
        ${pkgs.eget}/bin/eget ariasmn/ugm --to $out/bin/ugm
        chmod +x $out/bin/ugm
      ''
    )
  ];
}
