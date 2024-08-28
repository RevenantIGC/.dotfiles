{ self, pkgs, ... }:
{
  networking = {
    hostId = "cc1f83cb";
    hostName = "revenantigc-workstation";
    firewall.checkReversePath = false;
  };
  services.minidlna.settings = {
    friendly_name = "revenantigc-workstation";
    media_dir = [
      "V,/home/revenantigc/data/Items/Videos"
      "A,/home/revenantigc/data/Items/Music"
    ];
  };

  services.xserver.serverFlagsSection = ''
    Option "BlankTime" "0"
    Option "StandbyTime" "0"
    Option "SuspendTime" "0"
    Option "OffTime" "0"
  '';

  development = {
    enable = true;
    languages = [
      "dotnet"
      "crystal"
      "f#"
      "ocaml"
      "elm"
      "elixir"
      "web"
      "zig"
      "node"
      "ruby"
      "scala"
      "haskell"
      "clojure"
      "rust"
      #"android"
      "aws"
      "clasp"
      "oracle-cloud"
      "devops"
      "kubernetes"
    ];
  };
  environment.systemPackages = with pkgs; [ qpwgraph ];
  services.xserver.windowManager.i3.extraSessionCommands = ''
    flameshot &
    uim-xim &
    qpwgraph -a &
    xrandr --output DP-1 --primary --mode 1920x1080 --output HDMI-1 --off
  '';
  services.picom = {
    enable = true;
    vSync = true;
  };
  services.xserver.deviceSection = ''Option "TearFree" "true"'';
  graphical-interface.enable = true;
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  /*
  # at some point create a nix container or something to host this server
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = AIZONE
      server string = smbnix
      netbios name = smbnix
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.15.4 127.0.0.1 localhost
      hosts allow = 192.168.15.2
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      hitobashira-ro = {
        path = "/home/revenantigc/Public/hitobashira-ro";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "hitobashira";
        #"force group" = "groupname";
      };
      hitobashira-w = {
        path = "/home/revenantigc/Public/hitobashira-w";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "hitobashira";
        #"force group" = "groupname";
      };
    };
  };

  */
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.15.4 127.0.0.1 localhost
      hosts allow = 192.168.15.100
      hosts allow = 192.168.15.23
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      data = {
        path = "/home/revenantigc/data";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "revenantigc";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  system.stateVersion = "22.11";
}
