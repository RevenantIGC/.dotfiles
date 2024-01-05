{ pkgs, ... }@attrs:
{
  languages.elixir.enable = true;
  packages = [
    pkgs.git
    pkgs.inotify-tools
  ];
  /*
  services.postgres = {
    enable = true;
    package = pkgs.postgresql_15;
    initialDatabases = [{ name = "mydb"; }];
    extensions = extensions: [
      extensions.postgis
      extensions.timescaledb
    ];
    settings.shared_preload_libraries = "timescaledb";
    initialScript = "CREATE EXTENSION IF NOT EXISTS timescaledb;";
  };
  */
}
