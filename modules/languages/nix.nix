{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.nix;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nil
      alejandra
      statix
      deadnix
    ];

    programs.nixvim.plugins.lsp.servers.nil_ls = {
      enable = true;
      cmd = ["nil"];
      filetypes = ["nix"];
      rootMarkers = ["flake.nix" "default.nix" ".git"];
      settings = {
        flake.autoEvalInputs = false;
        diagnostics = {
          statix.enable = true;
          deadnix.enable = true;
          ignored = ["unused_binding" "unused_with"];
        };
      };
    };
  };
}
