{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  alsa-lib,
  libX11,
  pcsclite,
}: let
  tlclient-png = fetchurl {
    url = "https://aur.archlinux.org/cgit/aur.git/plain/tlclient.png?h=tlclient";
    sha256 = "sha256-4M1dW211JnLMIHrQmP4ogiaNksOVit841XFIHhkQxe8=";
    name = "tlclient-png";
  };
  version = "4.17.0-3543";
  pname = "tlclient";

  src = fetchurl {
    url = "https://www.cendio.com/downloads/clients/tl-${version}-client-linux-dynamic-x86_64.tar.gz";
    hash = "sha256-7pl97xGNFwSDpWMpBvkz/bfMsWquVsJVGB+feWJvRQY=";
  };
in
  stdenv.mkDerivation rec {
    inherit pname version;
    inherit src;

    nativeBuildInputs = [autoPatchelfHook copyDesktopItems];
    propagatedBuildInputs = [alsa-lib libX11 pcsclite];

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      install -Dm644 "lib/tlclient/EULA.txt" "$out/share/licenses/tlclient/EULA.txt"
      install -m644 "lib/tlclient/open_source_licenses.txt" "$out/share/licenses/tlclient/open_source_licenses.txt"
      cp -R lib "$out/"

      install -Dm644 "etc/tlclient.conf" "$out/etc/tlclient.conf"
      install -Dm755 "bin/tlclient" "$out/bin/tlclient"
      install -Dm755 "bin/tlclient-openconf" "$out/bin/tlclient-openconf"

      install -Dm644 "${tlclient-png}" "$out/share/tlclient/tlclient.png"

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        desktopName = "ThinLinc Client";
        name = "tlclient";
        exec = "tlclient";
        icon = "tlclient";
        comment = meta.description;
        type = "Application";
        categories = ["Network" "RemoteAccess"];
      })
    ];

    meta = {
      description = "Linux remote desktop client built on open source technology";
      license = {
        fullName = "Cendio End User License Agreement 3.2";
        url = "https://www.cendio.com/thinlinc/docs/legal/eula";
        free = false;
      };
      homepage = "https://www.cendio.com/";
      platforms = ["x86_64-linux"];
    };
  }
