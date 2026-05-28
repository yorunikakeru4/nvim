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
      lldb
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

    programs.nixvim.extraConfigLua = ''
      -- lldb adapter for Rust (also reused for C/C++)
      local dap = require("dap")
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-dap",
        name = "lldb",
      }
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = vim.fn.getcwd(),
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.c   = dap.configurations.rust
      dap.configurations.cpp = dap.configurations.rust
    '';
  };
}
