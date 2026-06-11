{...}: {
  # Per-filetype run/test/build/repl via switchboard.nvim.
  # Replaces the old hand-rolled BufEnter keymap logic from keymaps.nix.
  #
  # Project-specific overrides (nix flake projects, stack vs cabal, cmake
  # builds, ...) go into a `.switchboard-config` lua file at the project root:
  #   return {
  #     commands = { run = "nix run", build = "nix build", test = "stack test" },
  #   }
  #
  # Note: `%` / `%:r` placeholders only expand in `split` mode (it goes
  # through `:terminal`); overlay/background use termopen and pass commands
  # verbatim — keep the keymaps below on `split`.
  programs.nixvim.extraConfigLua = ''
    require("switchboard").setup({
      notify_missing_project_config = false,
      local_config = ".switchboard-config",
      bottom_height_percent = 30,
      build_run_config = {
        {
          extension = { "py" },
          commands = { run = "python3 %", test = "pytest" },
        },
        {
          extension = { "js", "mjs", "cjs" },
          commands = { run = "node %", test = "npm test", build = "npm run build" },
        },
        {
          extension = { "php" },
          commands = { run = "php %", test = "phpunit", build = "composer install" },
        },
        {
          extension = { "go" },
          commands = { run = "go run %", test = "go test ./..." },
        },
        {
          extension = { "c", "h" },
          cd_root = true,
          commands = { run = "gcc % -o %:r && ./%:r", build = "make" },
        },
        {
          extension = { "cpp", "cc", "hpp" },
          cd_root = true,
          commands = {
            run = "g++ -std=c++23 % -o %:r && ./%:r",
            build = "cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && cmake --build build",
          },
        },
        {
          extension = { "rs" },
          commands = { run = "cargo run --release", test = "cargo test", build = "cargo build" },
        },
        {
          extension = { "hs" },
          commands = { run = "runghc %", test = "cabal test", build = "cabal build", repl = "cabal repl" },
        },
        {
          extension = { "ex", "exs" },
          commands = { run = "elixir %", test = "mix test" },
        },
        {
          extension = { "nix" },
          commands = { run = "nix run", build = "nix build" },
        },
      },
    })

    local sb_opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>E", ":Switchboard overlay run<CR>", sb_opts)
    vim.keymap.set("n", "<leader>T", ":Switchboard overlay test<CR>", sb_opts)
    vim.keymap.set("n", "<leader>B", ":Switchboard overlay build<CR>", sb_opts)
    vim.keymap.set("n", "<leader>I", ":Switchboard overlay repl<CR>", sb_opts)
  '';
}
