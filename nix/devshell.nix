{ pkgs, perSystem }:
pkgs.mkShell {
  packages =
    with pkgs;
    [
      elixir
      perSystem.self.formatter
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ];
}
