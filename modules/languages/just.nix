{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.just;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [just-lsp];

    programs.nixvim.plugins.lsp.servers.just = {
      enable = true;
      cmd = ["just-lsp"];
      filetypes = ["just"];
      rootMarkers = ["justfile" "Justfile" ".git"];
      settings.just.diagnostics.enable = true;
    };
  };
}
