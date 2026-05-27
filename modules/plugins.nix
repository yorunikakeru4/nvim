{
  pkgs,
  nvimFlakeInputs,
  ...
}: let
  custom = nvimFlakeInputs.nvim-plugins.packages.${pkgs.stdenv.hostPlatform.system};
in {
  home.packages = with pkgs; [
    mercurial
    tree-sitter
  ];

  programs.nixvim = {
    plugins = {
      web-devicons = {
        enable = true;
        settings = {
          strict = true;
          color_icons = true;
          default = true;
          variant = "dark";
          blend = 0;
          override_by_filename = {
            ".gitignore" = {
              icon = "";
              color = "#f1502f";
              name = "Gitignore";
            };
            "docker-compose.yml" = {
              icon = "󱨸";
              color = "#2496ED";
              name = "DockerCompose";
            };
            "go.mod" = {
              icon = "";
              color = "#68E4FC";
              name = "GoMod";
            };
            "go.sum" = {
              icon = "󰞆";
              color = "#68E4FC";
              name = "GoSum";
            };
            "main.go" = {
              icon = "";
              color = "#68E4FC";
              name = "MainGo";
            };
            "requirements.txt" = {
              icon = "";
              color = "#5C3A39";
              name = "RequirementsTxt";
            };
            ".env" = {
              icon = "";
              color = "#89E051";
              name = "Env";
            };
            "README.md" = {
              icon = "";
              color = "#EE4B38";
              name = "README";
            };
          };
          override_by_extension = {
            yml = {
              icon = "󰸌";
              color = "#DC2626";
              name = "Yml";
            };
            go = {
              icon = "󱍢";
              color = "#68E4FC";
              name = "Go";
            };
            rs = {
              icon = "";
              color = "#DC2626";
              name = "rust";
            };
            py = {
              icon = "";
              color = "#53FBBA";
              name = "python";
            };
            php = {
              icon = "";
              color = "#787CB5";
              name = "php";
            };
            lua = {
              icon = "";
              color = "#106EF9";
              name = "Lua";
            };
            json = {
              icon = "󰘦";
              color = "#F5C359";
              name = "Json";
            };
            yuck = {
              icon = "󱀆";
              color = "#CA62FC";
              name = "Yuck";
            };
            ex = {
              icon = "";
              color = "#CA31FC";
              name = "elixir";
            };
            exs = {
              icon = "";
              color = "#CA99FC";
              name = "elixir";
            };
          };
        };
      };
      treesitter = {
        enable = true;
        settings = {
          auto_install = false;
          highlight.enable = true;
          ensure_installed = [
            "lua"
            "vim"
            "go"
            "rust"
            "javascript"
            "typescript"
            "tsx"
            "vue"
            "css"
            "scss"
            "html"
            "json"
            "yaml"
            "toml"
            "markdown"
            "bash"
            "haskell"
          ];
        };
      };
      lsp.enable = true;
      cmp.enable = true;
      luasnip.enable = true;
      conform-nvim.enable = true;
      telescope.enable = true;
      oil.enable = true;
      nvim-tree.enable = true;
      gitsigns.enable = true;
      toggleterm.enable = true;
      comment.enable = true;
      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      todo-comments.enable = true;
      fidget.enable = true;
      emmet = {
        enable = true;
        settings = {
          leader_key = "<C-e>";
          settings.php.extends = "html";
        };
      };
      lualine.enable = true;
      indent-blankline.enable = true;
      colorizer.enable = true;
      flash.enable = true;
      aerial.enable = true;
      diffview.enable = true;
      undotree.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
      gruvbox-baby
      gruvbox-material
      rainbow-delimiters-nvim
      vim-illuminate
      vim-sandwich
      range-highlight-nvim
      nvim-treesitter-textobjects
      vim-matchup
      hlargs-nvim
      telescope-fzf-native-nvim
      fzf-lua
      gx-nvim
      vim-fugitive
      gv-vim
      lazygit-nvim
      nvim-lint
      cmp-git
      cmp-buffer
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      friendly-snippets
      copilot-lua
      copilot-cmp
      cmp-dotenv
      nix-develop-nvim
      comment-box-nvim
      outline-nvim
      trouble-nvim
      # data
      vim-dadbod
      vim-dadbod-ui
      vim-dadbod-completion
      # misc
      vim-dispatch
      tabular
      vim-markdown
      neodev-nvim
      nvim-jqx
      vimtex
      # language-specific (nixpkgs)
      haskell-scope-highlighting-nvim
      # custom plugins (from nvim-plugins sub-flake)
      custom.hbac-nvim
      custom.stcursorword
      custom.vim-autoread
      custom.seeker-nvim
      custom.signup-nvim
      custom.markdown-plus-nvim
      custom.vim-highlighturl
      custom.gopher-nvim
      custom.gotests-nvim
      custom.go-impl-nvim
      custom.goplements-nvim
      custom.go-tagger-nvim
      custom.vim-php-cs-fixer
    ];
  };
}
