{
  pkgs,
  flake,
}:
pkgs.beamPackages.mixRelease {
  mixNixDeps = pkgs.callPackages "${flake}/deps.nix" { };

  pname = "docs";
  version = "0.1.0";

  src = flake;

  removeCookie = false;
  stripDebug = true;

  DATABASE_URL = "";
  SECRET_KEY_BASE = "";

  buildPhase = ''
    mix do \
      app.config --no-deps-check --no-compile, \
      docs --warnings-as-errors
  '';

  installPhase = ''
    mkdir -p $out/lib/doc

    cp -r ./doc/. $out/lib/doc
  '';
}
