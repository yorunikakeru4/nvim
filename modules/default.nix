{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./languages.nix
    ./plugins.nix
    ./lsp.nix
    ./completion.nix
    ./formatting.nix
    ./treesitter.nix
    ./theme.nix
    ./keymaps.nix
    ./plugin-configs
    ./languages/go.nix
    ./languages/rust.nix
    ./languages/python.nix
    ./languages/web.nix
    ./languages/nix.nix
    ./languages/lua.nix
    ./languages/php.nix
    ./languages/elixir.nix
    ./languages/cpp.nix
    ./languages/haskell.nix
    ./languages/docker.nix
    ./languages/markdown.nix
    ./languages/sql.nix
    ./languages/just.nix
    ./languages/toml.nix
    ./languages/shell.nix
    ./languages/yaml.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    opts = {
      number = true;
      relativenumber = true;
      tabstop = 4;
      shiftwidth = 4;
      expandtab = true;
      termguicolors = true;
      mouse = "";
      clipboard = "unnamedplus";
      laststatus = 3;
      showmode = false;
      pumheight = 7;
      swapfile = false;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      incsearch = true;
      hlsearch = true;
      scrolloff = 8;
      cursorline = true;
      cursorlineopt = "number";
      signcolumn = "yes";
      updatetime = 200;
      timeoutlen = 800;
      synmaxcol = 240;
      confirm = true;
      hidden = true;
      wrap = true;
      linebreak = true;
      breakindent = true;
      showbreak = "↳ ";
      breakat = "!@-/\\ ";
      fillchars = {eob = " ";};
      completeopt = ["menu" "menuone" "noselect"];
      grepprg = "rg --vimgrep";
      spelllang = ["en" "ru"];
      shell = "fish";
    };

    globals.mapleader = " ";
  };
}
