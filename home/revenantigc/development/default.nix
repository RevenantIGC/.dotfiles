{ self, lib, pkgs, specialArgs, ... }@attrs:
with specialArgs;
let
  bin = "${pkgs.direnv}/bin/direnv";
  direnvAllow = (path: "$DRY_RUN_CMD sh -c 'if [ -f \"${path}/.envrc\" ]; then ${bin} allow \"${path}\"; fi;'");
in
{
  home.packages = with pkgs; [
    fd
    wget
    unzip
    tree-sitter
    ripgrep
    roboto
    scientifica
    powerline-fonts
    sshfs
    bottom
    eza
    bat
    graphviz
    ngrok
    insomnia
    ghidra
  ];

  fonts.fontconfig.enable = true;
  home.sessionVariables.ELIXIR_ERL_OPTIONS = "+fnu";

  programs.neovim = { enable = true; } // ((import (self + /home/revenantigc/development/nvim) attrs) pkgs);
  #programs.doom-emacs = { enable = true; } // ((import (self + /home/revenantigc/development/emacs) attrs) pkgs);
  home.activation = {
    direnvAllow = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${direnvAllow "$HOME"}
    '';
  };
}
