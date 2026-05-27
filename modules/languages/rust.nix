{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.rust;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rust-analyzer
      clippy
      rustfmt
    ];

    programs.nixvim.plugins.lsp.servers.rust_analyzer = {
      enable = true;
      installCargo = false;
      installRustc = false;
      cmd = ["rust-analyzer"];
      filetypes = ["rust"];
      rootMarkers = ["Cargo.toml" "Cargo.lock" ".git"];
      extraOptions.settings."rust-analyzer" = {
        check.command = "check";
        completion = {
          autoimport.enable = true;
          autoself.enable = true;
          callable.snippets = "fill_arguments";
        };
        inlayHints = {
          typeHints.enable = true;
          parameterHints.enable = true;
          chainingHints.enable = true;
          lifetimeElisionHints.enable = "always";
          implicitDrops.enable = true;
          maxLength.__raw = "nil";
        };
      };
    };

    programs.nixvim.plugins.crates = {
      enable = true;
      settings = {
        lsp = {
          enabled = true;
          actions = true;
          completion = true;
          hover = true;
        };
      };
    };
  };
}
