{
  flake,
  inputs,
  pkgs,
  system,
  ...
}:
let
  treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs {
    projectRootFile = "flake.nix";

    programs.deadnix.enable = true;
    programs.nixfmt.enable = true;

    programs.shfmt.enable = true;

    programs.prettier.enable = true;

    settings.formatter.mix-fmt = {
      command = "${flake.packages.${system}.mixFmt}/bin/mix-fmt";
      includes = [
        "*.ex"
        "*.exs"
        "*.heex"
      ];
    };
  };
  formatter = treefmtEval.config.build.wrapper;
  check = treefmtEval.config.build.check flake;
in
formatter
// {
  passthru = formatter.passthru // {
    tests = pkgs.lib.optionalAttrs (system == "x86_64-linux") {
      inherit check;
    };
  };
}
