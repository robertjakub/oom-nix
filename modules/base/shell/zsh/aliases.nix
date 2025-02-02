{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;
in {
  cat = ''${getExe pkgs.bat} --paging=never --theme="Solarized (dark)"'';
  less = ''${getExe pkgs.bat} --paging=always --style=changes --color=always --theme="Solarized (dark)"'';
  ls = "${getExe pkgs.eza}";
  l = ''${getExe pkgs.eza} -abgHhl@ --git --color=always --group-directories-first'';
  tree = "${getExe pkgs.eza} --tree --color=always";
  mc = "command ${getExe pkgs.mc} -u";

  # fasd
  a = "fasd -a"; # any
  s = "fasd -si"; # show / search / select
  d = "fasd -d"; # directory
  f = "fasd -f"; # file
  sd = "fasd -sid"; # interactive directory selection
  sf = "fasd -sif"; # interactive file selection
  z = "fasd_cd -d"; # cd, same functionality as j in autojump
  zz = "fasd_cd -d -i"; # cd with interactive selection
  v = "f -e nvim";
  j = "z";
}
