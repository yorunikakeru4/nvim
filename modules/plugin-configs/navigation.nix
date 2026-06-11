{...}: {
  programs.nixvim = {
    plugins = {
      nvim-tree.settings = {
        on_attach.__raw = ''
          function(bufnr)
            local api = require("nvim-tree.api")
            api.config.mappings.default_on_attach(bufnr)
            vim.keymap.set("n", "?", api.tree.toggle_help, { buffer = bufnr, noremap = true, silent = true })
            vim.keymap.set("n", "<leader>d", api.tree.change_root_to_node, { buffer = bufnr, noremap = true, silent = true })
          end
        '';
        view = {
          width = 50;
          side = "left";
        };
        live_filter.always_show_folders = true;
        renderer = {
          group_empty = true;
          root_folder_label = ":~:s?$?/..?";
          icons.show = {
            file = true;
            folder = true;
            folder_arrow = true;
            git = true;
            modified = true;
            hidden = true;
          };
        };
        actions.change_dir = {
          enable = true;
          global = true;
          restrict_above_cwd = false;
        };
        sync_root_with_cwd = true;
      };

      telescope.settings = {
        defaults = {
          layout_strategy = "flex";
          layout_config = {
            width = 0.95;
            height = 0.9;
            horizontal = {
              prompt_position = "top";
              preview_width = 0.58;
              preview_cutoff = 1;
            };
            vertical = {
              prompt_position = "top";
              preview_height = 0.55;
              preview_cutoff = 1;
            };
            flex.flip_columns = 120;
          };
          sorting_strategy = "ascending";
          dynamic_preview_title = true;
          path_display = ["smart"];
          winblend = 0;
          preview.hide_on_startup = false;
        };
        pickers = {
          find_files.previewer = true;
          git_files.previewer = true;
          live_grep.previewer = true;
          grep_string.previewer = true;
        };
      };

      marks = {
        enable = true;
        settings = {};
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>fa";
        action = ":Seeker files<CR>";
        options = {
          noremap = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>fw";
        action = ":Seeker grep_word<CR>";
        options = {
          noremap = true;
          silent = true;
        };
      }
    ];

    extraConfigLua = ''
      -- outline
      require("outline").setup({
        outline_window = { position = "right", relative_width = false, width = 40,
                           focus_on_open = true, show_numbers = false,
                           show_relative_numbers = true },
        preview_window = { auto_preview = true },
        symbol_folding = { autofold_depth = nil },
      })

      local trouble = require("trouble")
      trouble.setup({
        auto_close = false,
        auto_open = false,
        auto_preview = true,
        auto_refresh = true,
        focus = true,
        follow = true,
        win = { position = "right", size = 40 },
        modes = {
          diagnostics = {
            groups = {
              { "directory" },
              { "filename", format = "{file_icon} {basename} {count}" },
            },
          },
        },
      })

      function _G.toggle_outline_sidebar()
        trouble.close()
        vim.cmd("Outline")
      end

      function _G.toggle_trouble_sidebar()
        vim.cmd("OutlineClose")
        trouble.toggle({ mode = "diagnostics", focus = true })
      end

      -- seeker.nvim
      require("seeker").setup({
        picker_provider = "telescope",
        picker_opts = {
          layout_strategy = "flex",
          layout_config = {
            width = 0.95, height = 0.9,
            horizontal = { prompt_position = "top", preview_width = 0.58, preview_cutoff = 1 },
            vertical   = { prompt_position = "top", preview_height = 0.55, preview_cutoff = 1 },
            flex = { flip_columns = 120 },
          },
          sorting_strategy = "ascending",
          dynamic_preview_title = true,
          path_display = { "smart" },
          previewer = true,
        },
      })
    '';
  };
}
