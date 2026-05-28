{...}: {
  programs.nixvim.plugins.auto-session = {
    enable = true;
    settings = {
      suppressed_dirs = ["~/" "~/Downloads" "/tmp"];
      session_lens = {
        load_on_setup = true;
        previewer = false;
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>ss";
      action = "<cmd>SessionSave<CR>";
      options = { noremap = true; silent = true; desc = "Save session"; };
    }
    {
      mode = "n";
      key = "<leader>sr";
      action = "<cmd>SessionRestore<CR>";
      options = { noremap = true; silent = true; desc = "Restore session"; };
    }
    {
      mode = "n";
      key = "<leader>sd";
      action = "<cmd>SessionDelete<CR>";
      options = { noremap = true; silent = true; desc = "Delete session"; };
    }
    {
      mode = "n";
      key = "<leader>sf";
      action = "<cmd>SessionSearch<CR>";
      options = { noremap = true; silent = true; desc = "Find session"; };
    }
  ];
}
