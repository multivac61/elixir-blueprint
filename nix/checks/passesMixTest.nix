{
  pkgs,
  flake,
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

  nativeBuildInputs = with pkgs; [
    postgresql
    postgresqlTestHook
  ];

  postgresqlTestSetupSQL = ''
    CREATE USER postgres WITH PASSWORD 'postgres' LOGIN CREATEDB SUPERUSER;
    CREATE DATABASE nix_phoenix_template_test WITH OWNER postgres;
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    export HOME=$TMPDIR

    mix do \
      app.config --no-deps-check --no-compile, \
      credo, \
      sobelow, \
      deps.audit, \
      test --no-deps-check

    runHook postCheck
  '';
}
