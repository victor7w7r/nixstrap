{
  pkgs,
  inputs,
  username,
  host,
  plasma-manager,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  nix.settings.allowed-users = [ "${username}" ];

  /*  imports = [

  ]
  ++ (if (host != "vm") || (host != "server") then [ (import ./gaming.nix) ] else [ ]);
  #if (host == "desktop") then [ ./../home/default.desktop.nix ]*/

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username host; };
    users.${username} = {
      imports = [
       ./bat
       ./btop
       ./fonts
       ./packages
       ./plasma
      ];
      modules = [ plasma-manager.homeModules.plasma-manager ];
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
    shell = pkgs.zsh;
    extraGroups = [
      "audio"
      "input"
      "kvm"
      "libvirtd"
      "libvirt-qemu"
      "networkmanager"
      "power"
      "qemu"
      "realtime"
      "storage"
      "tty"
      "users"
      "video"
      "wheel"
    ];
  };
}
