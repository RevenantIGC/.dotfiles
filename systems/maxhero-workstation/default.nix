{ self, nixpkgs, nix-doom-emacs, home-manager, ... }@attrs:
let
  home-module = import (self + /home/maxhero) attrs;
in 
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = attrs;
  modules = [
    # TODO: Add Media Generation later
    #(nixpkgs + /nixos/modules/installer/cd-dvd/installation-cd-minimal.nix)
    #(nixpkgs + /nixos/modules/installer/cd-dvd/channel.nix)
    (self + /modules/common)
    (self + /modules/development)
    (self + /modules/graphical-interface)
    (self + /modules/gaming)
    (self + /modules/networking)
    (self + /modules/sound)
    (self + /modules/vfio)
    (self + /modules/wireguard-client.nix)
    (self + /modules/bare-metal)
    ./configuration.nix
    ./hardware-configuration.nix
    home-manager.nixosModules.home-manager
    ({ config, ... }: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.maxhero = home-module.mkHome {
          enableDoomEmacs = true;
          enableDevelopment = true;
          enableUI = true;
          enableGaming = true;
        };
        extraSpecialArgs = attrs // {
          inherit nix-doom-emacs;
          nixosConfig = config;
        };
      };
    })
  ];
}
