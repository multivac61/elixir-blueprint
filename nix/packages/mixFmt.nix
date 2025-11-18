{
  pkgs,
  flake,
  ...
}:
pkgs.beamPackages.mixRelease {
  mixNixDeps = pkgs.callPackages "${flake}/deps.nix" { };

  pname = "mix-fmt";
  version = "0.1.0";

  src = flake;

  DATABASE_URL = "";
  SECRET_KEY_BASE = "";

  doCheck = true;

  preCheck = ''
    export HOME=$TMPDIR
    cat > $HOME/.gitconfig <<EOF
    [user]
      name = Nix
      email = nix@localhost
    [init]
      defaultBranch = main
    EOF
  '';

  checkPhase = ''
    runHook preCheck

    git init --quiet
    git add .
    git commit -m init --quiet

    trap 'echo "Try running \"nix fmt\" to correct the formatting error."' ERR

    mix "do" \
      app.config --no-deps-check --no-compile, \
      format

    git status --short
    git --no-pager diff --exit-code

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    echo "mix formatting check passed" > $out/result
    runHook postInstall
  '';
}
