{
  pkgs,
  flake,
  perSystem,
  ...
}:
pkgs.beamPackages.mixRelease {
  mixNixDeps = pkgs.callPackages "${flake}/deps.nix" { };

  pname = "is-formatted";
  version = "0.1.0";

  src = flake;

  DATABASE_URL = "";
  SECRET_KEY_BASE = "";

  nativeBuildInputs = [
    perSystem.self.formatter
  ];

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

    treefmt --no-cache

    trap 'echo "Try running \"nix fmt\" to correct the formatting error."' ERR

    git status --short
    git --no-pager diff --exit-code
  '';
}
