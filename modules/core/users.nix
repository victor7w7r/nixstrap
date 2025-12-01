{
  pkgs,
  inputs,
  username,
  host,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  nix.settings.allowed-users = [ "${username}" ];
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username host; };
    users.${username} = {
      imports = [ ./../home ];
      #if (host == "desktop") then
      # [ ./../home/default.desktop.nix ]
      #else
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
      };
      programs.home-manager.enable = true;
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "audio"
      "input"
      "kvm"
      "networkmanager"
      "input"
      "power"
      "libvirtd"
      "storage"
      "tty"
      "users"
      "video"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
