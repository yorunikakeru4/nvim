{...}: {
  programs.nixvim = {
    plugins = {
      neogen = {
        enable = true;
        settings = {};
      };

      lspkind = {
        enable = true;
        cmp.enable = false;
        settings = {};
      };

      fidget.settings = {
        progress = {
          display = {
            render_limit = 5;
            done_ttl = 2;
            done_icon = "✓";
            progress_style = "FidgetProgress";
            done_style = "FidgetDone";
            group_style = "FidgetGroup";
            icon_style = "FidgetIcon";
            progress_icon.pattern = "dots";
          };
          poll_rate = 0;
          suppress_on_insert = false;
          ignore_done_already = false;
          ignore = ["lua_ls"];
        };
        notification.window = {
          winblend = 0;
          relative = "editor";
        };
        notification.override_vim_notify = false;
      };

      lspsaga = {
        enable = true;
        settings = {
          symbol_in_winbar.enable = false;
          implement.enable = false;
          lightbulb.enable = false;
        };
      };

      lazydev = {
        enable = true;
        settings.library = [
          {
            path = "\${3rd}/luv/library";
            words = ["vim%.uv"];
          }
        ];
      };
    };

    extraConfigLua = ''
      -- copilot
      vim.defer_fn(function()
        require("copilot").setup({
          suggestion = { enabled = true },
          panel      = { enabled = true },
        })
      end, 100)
      require("copilot_cmp").setup()

      -- signup.nvim (signature help)
      require("signup").setup({})
    '';
  };
}
