{
  pkgs,
  flake,
  ...
}:
let
  mixNixDeps = pkgs.callPackages "${flake}/deps.nix" { };
in
pkgs.beamPackages.mixRelease {
  inherit mixNixDeps;

  pname = "mix-fmt";
  version = "0.1.0";
  src = flake;

  DATABASE_URL = "";
  SECRET_KEY_BASE = "";

  # Don't build a release, just compile
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/source

    # Copy source and build artifacts
    cp -r . $out/source/

    # Create wrapper script
    cat > $out/bin/mix-fmt <<EOF
    #!/bin/sh
    set -euo pipefail
    cd $out/source
    export MIX_ENV=dev
    export HOME=\''${HOME:-\$TMPDIR}
    ${pkgs.beamPackages.elixir}/bin/mix format "\$@"
    EOF

    chmod +x $out/bin/mix-fmt

    runHook postInstall
  '';
}
