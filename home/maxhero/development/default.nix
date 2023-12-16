{ self, pkgs, config, lib, specialArgs, ... }:
with specialArgs;
let
  bin = "${pkgs.direnv}/bin/direnv";
  direnvAllow = (path: "$DRY_RUN_CMD sh -c 'if [ -f \"${path}/.envrc\" ]; then ${bin} allow \"${path}\"; fi;'");
  vscode-pkg =
    (pkgs.vscode-with-extensions.override {
      vscodeExtensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        ms-vsliveshare.vsliveshare
        elixir-lsp.vscode-elixir-ls
        phoenixframework.phoenix
        elmtooling.elm-ls-vscode
        mkhl.direnv
        tabnine.tabnine-vscode
        vscodevim.vim
        rust-lang.rust-analyzer
        redhat.vscode-yaml
        redhat.vscode-xml
        prisma.prisma
        ocamllabs.ocaml-platform
        ms-vscode.makefile-tools
        ms-vscode.live-server
        ms-vscode.hexeditor
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.47.2";
          sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
        }
      ];
    });
in
{
  config = lib.mkIf nixosConfig.development.enable {
    home.packages = with pkgs; [
      ripgrep
      roboto
      scientifica
      powerline-fonts
      sshfs
      bottom
      eza
      bat
      graphviz
      vscode-pkg
      ngrok
      insomnia
    ];

    fonts.fontconfig.enable = true;
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };

    programs.kitty = {
      enable = true;
      theme = "Monokai Classic";
      settings = {
        transparency = "yes";
	background_opacity = "0.8";
      };
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;
      extraLuaConfig = ''
        vim.g.mapleader = " "
	
        vim.opt.nu = true
        vim.opt.relativenumber = true

        vim.opt.tabstop = 2
        vim.opt.softtabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true

        vim.opt.wrap = false

        vim.opt.swapfile = false

        vim.opt.incsearch = true

        vim.opt.scrolloff = 8

        vim.opt.colorcolumn = "80,100,120"

        vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      '';
      plugins = with pkgs; [
        { plugin = vimPlugins.vim-monokai; config = "colorscheme monokai"; }
        { plugin = vimPlugins.telescope-nvim; config = ":luafile ${(self + /home/maxhero/development/nvim/plugin/telescope.lua)}"; }
        { plugin = vimPlugins.nvim-treesitter.withAllGrammars; config = ":luafile ${(self + /home/maxhero/development/nvim/plugin/treesitter.lua)}";}
        { plugin = vimPlugins.lsp-zero-nvim; config = ":luafile ${(self + /home/maxhero/development/nvim/plugin/lsp-zero.lua)}";}
        vimPlugins.nvim-treesitter-context
        vimPlugins.nvim-treesitter-refactor
        vimPlugins.undotree 
      ];
      /*generatedConfigs = {
        viml = "";
      	lua = ''
        '';
      };
      */
    };

    home.activation = {
      direnvAllow = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${direnvAllow "$HOME"}
      '';
    };

    programs.git = {
      enable = true;
      userName = "Marcelo Amancio de Lima Santos";
      userEmail = "contact@maxhero.dev";
      extraConfig = {
        rerere.enabled = true;
        pull.rebase = true;
        tag.gpgsign = true;
        init.defaultBranch = "master";
        core = {
          excludesfile = "$NIXOS_CONFIG_DIR/scripts/gitignore";
          editor = "${pkgs.vim}/bin/vim";
        };
      };
      includes = [{
        condition = "gitdir:/home/maxhero/projects/mindlab/";
        contents.user.email = "marcelo.amancio@mindlab.com.br";
      }];
    };
    /*programs.doom-emacs = {
      enable = true;
      doomPrivateDir = self + /home/maxhero/development/doom.d;
      package = pkgs.emacsGcc;
      extraPackages = [
        pkgs.nodePackages.typescript
        pkgs.nodePackages.typescript-language-server
        pkgs.nodePackages.eslint
        pkgs.metals
        pkgs.haskellPackages.lsp
      ];
      emacsPackagesOverlay = self: super: {
        magit-delta = super.magit-delta.overrideAttrs
          (esuper: {
            buildInputs = esuper.buildInputs ++ [
              pkgs.git
            ];
          });
      };
    };*/

    programs.ssh.matchBlocks = {
      "github.com-mindlab" = {
        hostname = "github.com";
        user = "maxhero-mindlab";
        identityFile = "~/.ssh/mindlab_ed25519";
      };
    };
  };
}
