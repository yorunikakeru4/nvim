# nixvim

<!--toc:start-->

- [nixvim](#nixvim)
  - [Usage](#usage)
    - [As a flake app](#as-a-flake-app)
    - [As a home-manager module](#as-a-home-manager-module)
    - [Build locally](#build-locally)
    - [Format](#format)
  - [Language support](#language-support)
  - [Plugins](#plugins)
  - [Keymaps](#keymaps)
    - [Motion](#motion)
    - [File](#file)
    - [UI toggles](#ui-toggles)
    - [Find (Telescope)](#find-telescope)
    - [LSP (`n` prefix)](#lsp-n-prefix)
    - [Diagnostics (`z` prefix)](#diagnostics-z-prefix)
    - [Highlights / hints (`p` prefix)](#highlights-hints-p-prefix)
    - [Splits (`s` prefix)](#splits-s-prefix)
    - [Buffers / tabs (`t` prefix)](#buffers-tabs-t-prefix)
    - [Terminal](#terminal)
    - [Git](#git)
    - [Run / Build / Test (context-aware)](#run-build-test-context-aware)
    - [Debug (DAP)](#debug-dap)
    - [Marks (`M` prefix)](#marks-m-prefix)
    - [Select all (`<leader>a` prefix)](#select-all-leadera-prefix)
    - [Replace](#replace)
    - [Line movement](#line-movement)
    - [Editing](#editing)
    - [Completion (insert mode)](#completion-insert-mode)
    - [Insert mode navigation](#insert-mode-navigation)
    - [Search](#search)
    - [NvimTree (inside tree buffer)](#nvimtree-inside-tree-buffer)
  - [Settings](#settings)
  <!--toc:end-->

Personal Neovim configuration built with [nixvim](https://github.com/nix-community/nixvim) on top of [home-manager](https://github.com/nix-community/home-manager).

- **Theme**: gruvbox-baby (transparent background)
- **Leader**: `<Space>`
  **Shell**: fish
- **Clipboard**: system (`unnamedplus`)

## Usage

### As a flake app

```bash
nix run github:yorunikakeru/nixvim
```

### As a home-manager module

```nix
# flake.nix
inputs.my-nixvim.url = "github:yorunikakeru/nixvim";

# home.nix
imports = [ inputs.my-nixvim.homeModules.default ];
```

### Build locally

```bash
nix build
nix run
```

### Format

```bash
nix fmt   # alejandra
```

## Language support

All languages are enabled by default. Disable via `nixvimLanguages.<lang>.enable = false`.

```nix
nixvimLanguages.go.enable = false;
```

| Language   | LSP                             | Formatter                           | Linter        | Extra                                       |
| ---------- | ------------------------------- | ----------------------------------- | ------------- | ------------------------------------------- |
| Go         | gopls, golangci-lint-langserver | goimports + gofmt                   | golangci-lint | gopher, gotests, go-impl, goplements, delve |
| Rust       | rust-analyzer                   | rustfmt                             | clippy        | crates.nvim, lldb DAP                       |
| Python     | pyright / pylsp                 | ruff_format + ruff_organize_imports | —             | nvim-dap-python                             |
| TypeScript | ts_ls                           | prettierd / prettier                | —             | —                                           |
| Vue        | volar                           | prettier                            | —             | —                                           |
| Nix        | nil / nixd                      | alejandra                           | —             | —                                           |
| Lua        | lua_ls                          | stylua                              | —             | lazydev                                     |
| PHP        | phpactor / intelephense         | php-cs-fixer                        | —             | vim-php-cs-fixer                            |
| Elixir     | elixirls                        | mix format                          | —             | —                                           |
| C/C++      | clangd                          | clang-format                        | —             | lldb DAP, switch header/source              |
| Haskell    | hls                             | ormolu                              | —             | haskell-scope-highlighting                  |
| Markdown   | —                               | prettierd                           | proselint     | render-markdown, markdown-plus              |
| SQL        | sqls                            | —                                   | —             | vim-dadbod, vim-dadbod-ui                   |
| Shell      | bashls                          | shfmt                               | shellcheck    | —                                           |
| Docker     | dockerls                        | —                                   | —             | —                                           |
| YAML       | yaml-language-server            | —                                   | —             | —                                           |
| TOML       | taplo                           | taplo                               | —             | —                                           |
| Just       | —                               | just                                | —             | —                                           |

## Plugins

| Category   | Plugin(s)                                                                     |
| ---------- | ----------------------------------------------------------------------------- |
| Completion | nvim-cmp, luasnip, friendly-snippets, cmp-dotenv                              |
| AI         | copilot.lua (inline + variants panel), copilot-lsp (NES)                      |
| LSP UI     | lspsaga, fidget, lspkind, neogen, signup.nvim (signature help)                |
| Navigation | telescope + fzf-native, oil.nvim, nvim-tree, seeker.nvim, outline.nvim, flash |
| Buffers    | nvim-cokeline (tabs), hbac (auto-close old buffers, threshold=10)             |
| Git        | gitsigns, lazygit, vim-fugitive, gv.vim, diffview                             |
| Terminal   | toggleterm (float, horizontal, tab)                                           |
| Editing    | nvim-autopairs, nvim-surround, comment.nvim, vim-matchup                      |
| Debug      | nvim-dap + dap-ui + dap-virtual-text                                          |
| Syntax     | treesitter, rainbow-delimiters, hlargs, vim-illuminate, treesitter-context    |
| UI         | lualine, indent-blankline, todo-comments, ccc (color preview), startup.nvim   |
| Misc       | undotree, trouble, nvim-jqx, gx.nvim, vim-autoread                            |

## Keymaps

### Motion

| Key | Mode | Action                         |
| --- | ---- | ------------------------------ |
| `q` | n, v | Jump to matching bracket (`%`) |
| `L` | n, v | End of line (`$`)              |
| `H` | n, v | First non-blank (`^`)          |

### File

| Key             | Action        |
| --------------- | ------------- |
| `<leader>w`     | Save          |
| `<leader>W`     | Save all      |
| `<leader>q`     | Quit          |
| `<leader><Esc>` | Save and quit |

### UI toggles

| Key         | Action             |
| ----------- | ------------------ |
| `<leader>e` | NvimTree           |
| `<leader>u` | Undotree           |
| `<leader>o` | Outline            |
| `<leader>l` | Oil (file browser) |

### Find (Telescope)

| Key          | Mode | Action                         |
| ------------ | ---- | ------------------------------ |
| `ff`         | n    | Find files                     |
| `fg`         | n    | Live grep                      |
| `fg`         | v    | Grep selected text             |
| `fb`         | n    | Buffers                        |
| `fh`         | n    | Help tags                      |
| `fr`         | n    | Recent files                   |
| `fd`         | n    | LSP definition                 |
| `<leader>fa` | n    | Seeker: all files              |
| `<leader>fw` | n    | Seeker: grep word under cursor |

### LSP (`n` prefix)

| Key          | Mode | Action                                    |
| ------------ | ---- | ----------------------------------------- |
| `nr`         | n    | Rename                                    |
| `nh`         | n    | Hover docs                                |
| `nd`         | n    | Go to definition (lspsaga)                |
| `nc`         | n, v | Code action                               |
| `na`         | n    | Fill struct / implement interface         |
| `nw`         | n    | References (lspsaga finder)               |
| `no`         | n    | Incoming calls                            |
| `nq`         | n    | Outgoing calls                            |
| `ng`         | n    | Generate docstring (neogen)               |
| `ni`         | n    | Smart change-inner (quotes/brackets/word) |
| `ns`         | n    | Prepend `$` to word under cursor          |
| `nt`         | v    | GoTagAdd (Go struct tag)                  |
| `<leader>F`  | n    | Format buffer                             |
| `<leader>a`  | n    | Restart LSP                               |
| `<A-CR>`     | i    | Open Copilot variants panel               |
| `<C-L>`      | i    | Accept inline Copilot suggestion          |
| `<A-[>`      | i    | Previous inline Copilot suggestion        |
| `<A-]>`      | i    | Next inline Copilot suggestion            |
| `<leader>cn` | n    | Accept Copilot next edit and go to end    |
| `<leader>cx` | n    | Dismiss Copilot next edit                 |
| `<leader>rh` | n    | Switch C/C++ source ↔ header              |

Inside the Copilot variants panel, use `j`/`k` or `]]`/`[[` to select,
`<CR>` to accept, `gr` to refresh, and `q`/`Esc` to close.

### Diagnostics (`z` prefix)

| Key  | Action                      |
| ---- | --------------------------- |
| `zj` | Telescope diagnostics list  |
| `zk` | Open diagnostic float       |
| `zh` | Jump to previous diagnostic |
| `zl` | Jump to next diagnostic     |

### Highlights / hints (`p` prefix)

| Key  | Action                           |
| ---- | -------------------------------- |
| `pd` | Clear search highlight           |
| `pe` | Highlight word under cursor      |
| `pt` | Toggle inlay hints + diagnostics |

### Splits (`s` prefix)

| Key         | Action                  |
| ----------- | ----------------------- |
| `sh`        | Horizontal split        |
| `sv`        | Vertical split          |
| `sc`        | Close split             |
| `so`        | Keep only current split |
| `sn`        | Next window             |
| `sp` / `sm` | Resize +5 / -5          |
| `<C-Arrow>` | Navigate to window      |

### Buffers / tabs (`t` prefix)

| Key       | Action                |
| --------- | --------------------- |
| `<Tab>`   | Next buffer           |
| `<C-Tab>` | Previous buffer       |
| `tc`      | Close buffer          |
| `to`      | Close all but current |

### Terminal

| Key     | Mode | Action              |
| ------- | ---- | ------------------- |
| `tf`    | n    | Float terminal      |
| `th`    | n    | Horizontal terminal |
| `tt`    | n    | Terminal in new tab |
| `<Esc>` | t    | Exit terminal mode  |

### Git

| Key          | Action       |
| ------------ | ------------ |
| `<leader>gg` | LazyGit      |
| `<leader>gh` | Git log (GV) |
| `<leader>gs` | Diff this    |

### Run / Build / Test (context-aware)

Mappings are set per-buffer based on filetype and detected project files (`flake.nix`, `Cargo.toml`, `go.mod`, etc.). In a `flake.nix` project, all three redirect to nix commands.

| Key         | Action                                                      |
| ----------- | ----------------------------------------------------------- |
| `<leader>E` | Run (language runner or `nix run`)                          |
| `<leader>B` | Build (cmake/make/cargo/stack/npm/nix build/…)              |
| `<leader>T` | Test (pytest/go test/cargo test/mix test/nix flake check/…) |
| `<leader>I` | REPL (Haskell: stack/cabal repl)                            |

### Debug (DAP)

| Key          | Mode | Action                 |
| ------------ | ---- | ---------------------- |
| `<F5>`       | n    | Continue               |
| `<F10>`      | n    | Step over              |
| `<F11>`      | n    | Step into              |
| `<F12>`      | n    | Step out               |
| `<leader>db` | n    | Toggle breakpoint      |
| `<leader>dB` | n    | Conditional breakpoint |
| `<leader>dr` | n    | Open REPL              |
| `<leader>dl` | n    | Run last               |
| `<leader>du` | n    | Toggle DAP UI          |
| `<leader>dx` | n    | Terminate              |
| `<leader>dh` | n, v | Hover value            |

### Marks (`M` prefix)

| Key  | Action                 |
| ---- | ---------------------- |
| `Mc` | Set mark (`m{char}`)   |
| `MC` | Set global mark A      |
| `MM` | Jump to mark (`` ` ``) |
| `Md` | Delete marks           |
| `MD` | Delete all marks       |

### Select all (`<leader>a` prefix)

| Key          | Action                |
| ------------ | --------------------- |
| `<leader>aa` | Select all            |
| `<leader>ac` | Copy all to clipboard |
| `<leader>ad` | Delete all            |

### Replace

| Key         | Mode | Action                       |
| ----------- | ---- | ---------------------------- |
| `<leader>v` | n    | `:%s/` (global replace)      |
| `<leader>v` | v    | `:s/` (replace in selection) |

### Line movement

| Key     | Mode | Action                    |
| ------- | ---- | ------------------------- |
| `<A-k>` | n    | Move line up              |
| `<A-j>` | n    | Move line down            |
| `<A-d>` | n    | Duplicate line            |
| `<A-d>` | x    | Duplicate selection below |
| `<A-k>` | v    | Move selection up         |
| `<A-j>` | v    | Move selection down       |
| `<A-l>` | v    | Indent right              |
| `<A-h>` | v    | Indent left               |

### Editing

| Key      | Mode | Action                             |
| -------- | ---- | ---------------------------------- |
| `<A-q>`  | n    | Toggle line comment                |
| `<A-qq>` | n    | Toggle block comment               |
| `s`      | v    | Surround selection (nvim-surround) |
| `nf`     | v    | Wrap selection with function call  |

### Completion (insert mode)

| Key              | Action                 |
| ---------------- | ---------------------- |
| `<A-j>`          | Select next item       |
| `<A-k>`          | Select previous item   |
| `<A-Tab>`        | Confirm selection      |
| `<leader>af` (n) | Toggle nvim-cmp on/off |

### Insert mode navigation

| Key     | Action  |
| ------- | ------- |
| `<C-h>` | ← Left  |
| `<C-j>` | ↓ Down  |
| `<C-k>` | ↑ Up    |
| `<C-l>` | → Right |

### Search

| Key | Action         |
| --- | -------------- |
| `;` | Next match     |
| `'` | Previous match |

### NvimTree (inside tree buffer)

| Key         | Action                      |
| ----------- | --------------------------- |
| `?`         | Toggle help                 |
| `<leader>d` | Change root to current node |

## Settings

- `relativenumber` + `number`
- `scrolloff = 8`, cursorline on number column only
- `undofile = true` — persistent undo
- `swapfile = false`
- `ignorecase` + `smartcase`
- `spelllang = ["en" "ru"]`
- `timeoutlen = 800`
- Arrow keys disabled in normal and insert mode
- Auto-format on save for all supported filetypes (JSONC and SQL skipped)
- Inlay hints enabled on LSP attach
- Document highlight on `CursorHold`
- Code lens refresh on `BufEnter` / `InsertLeave`
- `sqls` and `html` LSP formatting providers disabled (conform-nvim handles them)
- DAP UI opens/closes automatically on session start/end
- Old buffers auto-closed when buffer count exceeds 10 (hbac)
