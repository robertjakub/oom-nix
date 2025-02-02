{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}: let
  # https://cdn.cribl.io/dl/4.9.3/cribl-4.9.3-25d56bdd-linux-x64.tgz
  # https://cdn.cribl.io/dl/4.9.3/cribl-4.9.3-25d56bdd-linux-arm64.tgz
  version = "4.9.3";
  srcs = {
    aarch64-linux = fetchurl {
      url = "https://cdn.cribl.io/dl/${version}/cribl-${version}-25d56bdd-linux-arm64.tgz";
      hash = "";
    };
    x86_64-linux = fetchurl {
      url = "https://cdn.cribl.io/dl/${version}/cribl-${version}-25d56bdd-linux-x64.tgz";
      hash = "sha256-e4jQScgh3FyUpjzHyDX2R5PKmEBaL/bUGoICQIUOR0M=";
    };
  };
in
  stdenv.mkDerivation {
    pname = "cribl";
    inherit version;
    src = srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    nativeBuildInputs = [autoPatchelfHook (stdenv.cc.cc)];

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/cribl/bin
      install -m 555 bin/cribl $out/cribl/bin
      install -m 444 bin/*.node $out/cribl/bin
      install -m 444 bin/libjemalloc.so $out/cribl/bin
      cp -r {data,default,lib,thirdparty} $out/cribl
      runHook postInstall
    '';

    outputs = ["out"];

    meta = with lib; {
      homepage = "https://www.cribl.io";
      description = "Your telemetry data management just got simpl.";
      license = licenses.unfree;
      sourceProvenance = with sourceTypes; [binaryNativeCode];
      platforms = builtins.attrNames srcs;
    };
  }
