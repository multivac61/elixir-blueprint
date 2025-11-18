{ pkgs, perSystem }:
pkgs.writeShellApplication {
  name = "mprocs";

  runtimeInputs = with pkgs; [
    mprocs
    elixir_1_19
    perSystem.self.docsWatch
    perSystem.self.postgresDev
  ];

  text = ''
    exec mprocs \
      "mix phx.server" \
      "mix test.watch --stale" \
      "postgres-dev" \
      "docsWatch"
  '';
}
