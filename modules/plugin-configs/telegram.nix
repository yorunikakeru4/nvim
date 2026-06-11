{
  pkgs,
  nvimFlakeInputs,
  ...
}: let
  # nixpkgs tdlib (1.8.63) too old for telegram.nvim (needs >= 1.8.64);
  # rebuild from the flake-locked tdlib-src.
  tdlib = pkgs.tdlib.overrideAttrs (_: {
    version = nvimFlakeInputs.tdlib-src.shortRev or "unknown";
    src = nvimFlakeInputs.tdlib-src;
  });
in {
  programs.nixvim = {
    extraConfigLua = ''
      require("telegram").setup({
        tdlib_path = "${tdlib}/lib/libtdjson.so",
        -- default data_dir is the plugin root in /nix/store (read-only)
        data_dir = vim.fn.stdpath("data") .. "/telegram",
        panel_position = "right",
      })

      vim.keymap.set("n", "<leader>tg", "<cmd>Tg<CR>", {
        desc = "Toggle Telegram",
        silent = true,
        noremap = true,
      })
    '';
  };
}
