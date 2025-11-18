{ pkgs, perSystem }:
pkgs.mkShell {
  packages =
    with pkgs;
    [
      elixir_1_19
      perSystem.self.formatter
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ];
}
