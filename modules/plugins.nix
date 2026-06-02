{
  pkgs,
  nvimFlakeInputs,
  ...
}: let
  custom = nvimFlakeInputs.nvim-plugins.packages.${pkgs.stdenv.hostPlatform.system};
  copilot-cmp-patched = pkgs.vimPlugins.copilot-cmp.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        substituteInPlace lua/copilot_cmp/source.lua \
          --replace-fail 'self.client.is_stopped()' 'self.client:is_stopped()'
      '';
  });
in {
  home.packages = with pkgs; [
    tree-sitter
  ];

  programs.nixvim = {
    plugins = {
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
            "markdown_inline"
            "bash"
            "haskell"
            "python"
            "nix"
            "elixir"
            "c"
            "cpp"
            "sql"
            "php"
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
      lualine.enable = true;
      indent-blankline.enable = true;
      flash.enable = true;
      diffview.enable = true;
      undotree.enable = true;
      mini-icons = {
        enable = true;
        mockDevIcons = true;
      };
    };

    extraPlugins = with pkgs.vimPlugins; [
      plenary-nvim
      gruvbox-baby
      gruvbox-material
      rainbow-delimiters-nvim
      vim-illuminate
      nvim-treesitter-textobjects
      vim-matchup
      hlargs-nvim
      nvim-cokeline
      telescope-fzf-native-nvim
      gx-nvim
      vim-fugitive
      gv-vim
      lazygit-nvim
      nvim-lint
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      friendly-snippets
      copilot-lua
      copilot-cmp-patched
      cmp-dotenv
      nix-develop-nvim
      outline-nvim
      trouble-nvim
      # data
      vim-dadbod
      vim-dadbod-ui
      vim-dadbod-completion
      # misc
      nvim-jqx
      # language-specific (nixpkgs)
      haskell-scope-highlighting-nvim
      # custom plugins (from nvim-plugins sub-flake)
      custom.hbac-nvim
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
      # dap helpers
      nvim-dap-virtual-text
      nvim-dap-go
      nvim-dap-python
    ];
  };
}
