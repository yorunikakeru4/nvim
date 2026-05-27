{
  lib,
  pkgs,
  config,
  ...
}: let
  langs = config.nixvimLanguages;
in {
  config = lib.mkMerge [
    (lib.mkIf (langs.typescript.enable || langs.vue.enable) {
      home.packages = with pkgs; [
        vtsls
        eslint
        nodePackages.prettier
        prettierd
      ];
    })

    (lib.mkIf langs.typescript.enable {
      programs.nixvim.plugins.lsp.servers.vtsls = {
        enable = true;
        cmd = ["vtsls" "--stdio"];
        filetypes = ["javascript" "javascriptreact" "typescript" "typescriptreact"];
        rootMarkers = ["tsconfig.json" "package.json" ".git"];
      };
    })

    (lib.mkIf langs.vue.enable {
      home.packages = with pkgs; [
        vue-language-server
      ];

      programs.nixvim.plugins.lsp.servers.vue_ls = {
        enable = true;
        cmd = ["vue-language-server" "--stdio"];
        filetypes = ["vue"];
        rootMarkers = ["package.json" "vue.config.js" "vite.config.js" "vite.config.ts" ".git"];
        extraOptions.init_options.vue.hybridMode = true;
      };
    })
  ];
}
