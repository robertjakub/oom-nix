{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop;
  fn = import ../../lib {inherit lib;};
  applefonts = pkgs.callPackage ((fn.relativeToRoot) "pkgs/applefonts") {};
in {
  options.modules.desktop.fonts = {
    enable = mkEnableOption "gnome";
  };
  config = mkIf (cfg.enable && cfg.fonts.enable) {
    fonts = {
      fontconfig.hinting.autohint = true;
      fontDir.enable = true;
      packages =
        [applefonts]
        ++ (with pkgs; [
          lato
          helvetica-neue-lt-std
          liberation_ttf
          corefonts
          vistafonts
          font-awesome
          fira
          raleway
          # martian-mono # FIXME
          nerd-fonts.droid-sans-mono
          nerd-fonts.jetbrains-mono
          nerd-fonts.fira-code
          nerd-fonts.fira-mono
          nerd-fonts.symbols-only
        ]);
    };
  };
}
