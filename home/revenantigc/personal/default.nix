{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Igor Alves da Costa";
    userEmail = "igoralvescosta666@gmail.com";
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
  };
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "vps.revenantigc.com.br".identityFile = "~/.ssh/id_ed25519";
      "github.com" = {
        hostname = "github.com";
        user = "therevenantigc";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
