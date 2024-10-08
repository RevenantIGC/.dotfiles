{ self, lib, pkgs, specialArgs, ... }@attrs:
let
  i3SwayCommon = import (self + /home/revenantigc/graphical-interface/i3sway-common) attrs;
  spawnables = import (self + /home/revenantigc/graphical-interface/spawnables) attrs;
in
{
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      terminal = spawnables.xorg.terminal;
      modifier = i3SwayCommon.modifier;
      assigns = { };
      bars = [ ];
      colors = { };
      focus.followMouse = true;
      fonts = {
        names = [ "scientifica" ];
        size = 8.0;
      };
      keybindings = i3SwayCommon.i3AndSwayKeybindings "xorg";
      floating.criteria = i3SwayCommon.floatingCriteria;
      window = i3SwayCommon.window;
      modes = lib.mkOptionDefault {
        "command_mode" = i3SwayCommon.commandMode;
      };
      # Could be the same as sway if I find programs that behave the same between Xorg and Wayland
      startup = [
        { command = "--no-startup-id ${spawnables.xorg.notification-daemon}"; }
        { command = "--no-startup-id ${spawnables.xorg.bar}"; always = true; }
        { command = "--no-startup-id ${spawnables.xorg.ime}"; }
        { command = "--no-startup-id ${spawnables.xorg.wallpaper}"; }
        { command = "--no-startup-id ${spawnables.xorg.network-applet}"; }
        #{ command = "--no-startup-id ${clipman}"; }
      ];
    };
  };
}
