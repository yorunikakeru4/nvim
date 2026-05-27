{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.elixir;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [elixir-ls];

    programs.nixvim.plugins.lsp.servers.elixirls = {
      enable = true;
      cmd = ["elixir-ls"];
      filetypes = ["elixir" "heex"];
      rootMarkers = ["mix.exs" ".git"];
      settings.elixirLS = {
        dialyzerEnabled = true;
        fetchDeps = true;
      };
    };
  };
}
