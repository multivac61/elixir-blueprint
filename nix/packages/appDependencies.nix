{ pkgs }:
pkgs.symlinkJoin {
  name = "appDependencies";
  paths =
    with pkgs;
    [
      postgresql
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ];
}
