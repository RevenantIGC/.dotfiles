{ self, nixpkgs, nix-doom-emacs, nur, ... }@attrs:
let
  lib = nixpkgs.lib;
  vscode-pkg = import (self + /home/revenantigc/development/vscode);
in
{
  mkHome =
    { username ? "revenantigc"
    , homeDirectory ? "/home/${username}"
    , enableDoomEmacs ? false
    , enableVSCode ? false
    , enableDevelopment ? false
    , personal ? false
    , enableGaming ? false
    , enableUI ? false
    , extraModules ? [ ]
    , extraPackages ? [ ]
    , extraVSCodeExtensions ? [ ]
    , ...
    }:
    {
      imports =
        [
          nur.hmModules.nur
          (self + /home/revenantigc/base)
        ]
        ++ (lib.optionals enableDoomEmacs [
          ({ pkgs, ... }@attrs: {
            home.file.".doom.d".source = self + /home/revenantigc/development/emacs/doom.d;
            programs.emacs = {
              enable = true;
              package = pkgs.emacs;
            };
          })
        ])
        ++ (lib.optionals enableDevelopment [
          (self + /home/revenantigc/development)
          (self + /home/revenantigc/shells/zsh.nix)
        ])
        ++ (lib.optionals personal [
          (self + /home/revenantigc/personal)
        ])
        ++ (lib.optionals enableGaming [ (self + /home/revenantigc/gaming) ])
        ++ (lib.optionals enableUI [
          (self + /home/revenantigc/graphical-interface/rofi)
          (self + /home/revenantigc/graphical-interface/eww)
          (self + /home/revenantigc/graphical-interface/dconf)
          (self + /home/revenantigc/graphical-interface/i3)
          (self + /home/revenantigc/graphical-interface)
        ])
        ++ [
          ({ pkgs, ... }: {
            home.packages = extraPackages ++ (lib.optionals enableVSCode [
              (vscode-pkg {
                inherit pkgs;
                extraExtensions = extraVSCodeExtensions;
              })
            ]);
            home.username = username;
            home.homeDirectory = lib.mkForce homeDirectory;
          })
        ]
        ++ extraModules;
    };
}
