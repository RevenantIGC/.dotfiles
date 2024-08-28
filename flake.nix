{
  # CEREAL REAL
  description = "RevenantIgc's Nix Flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-doom-emacs.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    nur.url = "github:nix-community/NUR";
    emacs-overlay.url  = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    bizhawk.url = "github:TASEmulators/BizHawk";
    bizhawk.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, nix-doom-emacs, devenv, devshell, bizhawk, ... }@attrs:
    rec {
      emuhawk = (import bizhawk.outPath {
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        mono = nixpkgs.legacyPackages.x86_64-linux.mono;
       }).emuhawk-latest;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
      mkHome = (import (self + /home/revenantigc) attrs).mkHome;
      mkSystem = (import (self + /modules) attrs).mkSystem;
      nixosConfigurations = {
        revenantigc-workstation = mkSystem {
          enableBareMetal = true;
          enableEmacs = false;
          enableDevelopment = true;
          enableGraphicalInterface = true;
          enableGaming = false;
          enableNetworking = true;
          enableSound = true;
          enableVFIO = true;
          enableWireguard = false;
          home = mkHome {
            personal = true;
            enableDoomEmacs = false;
            enableDevelopment = true;
            enableVSCode = true;
            enableUI = true;
            enableGaming = false;
          };
          extraModules = [
            (self + /systems/revenantigc-workstation/configuration.nix)
            (self + /systems/revenantigc-workstation/hardware-configuration.nix)
          ];
          specialArgs = attrs;
        };
        revenantigc-pi4 = import (self + /systems/revenantigc-pi4) attrs;
        uchigatana = mkSystem {
          enableBareMetal = true;
          enableDevelopment = true;
          enableGraphicalInterface = true;
          enableGaming = true;
          enableNetworking = true;
          enableSound = true;
          enableVFIO = true;
          enableWireguard = true;
          home = mkHome {
            personal = true;
            enableVSCode = true;
            enableDevelopment = true;
            enableUI = true;
            enableGaming = true;
          };
          extraModules = [
            (self + /systems/uchigatana/configuration.nix)
            (self + /systems/uchigatana/hardware-configuration.nix)
          ];
          specialArgs = attrs;
        };
      };
    };
}
