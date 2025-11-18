{ pkgs }:
pkgs.writeShellApplication {
  name = "mix-fmt";

  runtimeInputs = with pkgs; [
    elixir_1_19
  ];

  text = ''
    exec mix "do" \
      app.config --no-deps-check --no-compile, \
      format
  '';
}
