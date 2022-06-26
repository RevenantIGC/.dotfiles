{
  # CEREAL REAL
  description = "Max Hero's Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    home-manager.url = "github:rycee/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, nur, ... }@attrs: {
    nixosConfigurations = {
      "maxhero-workstation" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./configuration.nix
          ./workstation/hardware-configuration.nix
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.maxhero = (import ./home/maxhero);
          }
        ];
      };
      "uchigatana" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = attrs;
        modules = [
          ./uchigatana/configuration.nix
          ./uchigatana/hardware-configuration.nix
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.users.maxhero = (import ./home/maxhero);
          }
        ];
      };
    };
  };
}
