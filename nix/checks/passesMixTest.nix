{
  pkgs,
  flake,
  perSystem,
  ...
}:
pkgs.beamPackages.mixRelease {
  mixNixDeps = pkgs.callPackages "${flake}/deps.nix" { };

  pname = "nix_phoenix_template_test";
  version = "0.1.0";

  src = flake;

  DATABASE_URL = "";
  SECRET_KEY_BASE = "";

  mixEnv = "test";

  nativeBuildInputs = [
    perSystem.self.postgresDev
    pkgs.postgresql
  ];

  doCheck = true;
  checkPhase = ''
    postgres-dev &

    until pg_isready -h /tmp ; do sleep 1 ; done

    export HOME=$TMPDIR

    mix do \
      app.config --no-deps-check --no-compile, \
      credo, \
      sobelow, \
      deps.audit, \
      test --no-deps-check
  '';
}
