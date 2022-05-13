{
  # CEREAL REAL
  description = "Max Hero's Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    home-manager.url = "github:rycee/home-manager";
  };

  outputs =
    { self, nixpkgs, ... }@attrs: {
      nixosConfigurations = {
        "maxhero-workstation" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = attrs;
          modules = [ ./configuration.nix ./workstation/hardware-configuration.nix ];
        };
#        "system76-kudu" = nixpkgs.lib.nixosSystem {
#          system = "x86_64-linux";
#          specialArgs = attrs;
#          modules = [ ./configuration.nix ./system76-kudu/hardware-configuration.nix ];
#        };
      };
    };
}
