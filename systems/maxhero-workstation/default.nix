{ nixpkgs, nix-doom-emacs, home-manager, ... }@attrs:
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = attrs;
  modules = [
    ../../modules/common
    ../../modules/development
    ../../modules/graphical-interface
    ../../modules/gaming
    ../../modules/networking
    ../../modules/sound
    ../../modules/vfio
    ../../modules/wireguard-client.nix
    ../../modules/bare-metal
    ./configuration.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    ({
      home-manager.useGlobalPkgs = true;
      home-manager.users.maxhero = ../../home/maxhero;
      home-manager.users.maxhero.graphical-interface.enable = true;
      home-manager.users.maxhero.gaming.enable = true;
      home-manager.users.maxhero.development.enable = true;
    })
  ];
}
