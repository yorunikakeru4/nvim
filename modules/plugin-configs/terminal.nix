{...}: {
  programs.nixvim.plugins.toggleterm.settings = {
    direction = "float";
    float_opts = {
      border = "none";
      width = 200;
      height = 50;
      winblend = 30;
    };
  };
}
