{lib, ...}: let
  inherit (lib) mkDefault;
in {
  system.defaults = {
    dock.autohide = mkDefault false;
    dock.autohide-delay = 0.10;
    dock.mru-spaces = false;
    # finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.LoginwindowText = "TrustNo1.corp (part of ACME)";
    universalaccess.mouseDriverCursorSize = 2.5;
    # screencapture.location = "~/Pictures/screenshots";
    # screensaver.askForPasswordDelay = 10;
  };
}
