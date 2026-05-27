{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.cpp;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [clang-tools];

    programs.nixvim.plugins.lsp.servers.clangd = {
      enable = true;
      cmd = [
        "clangd"
        "--background-index"
        "--clang-tidy"
        "--header-insertion=iwyu"
        "--completion-style=detailed"
        "--function-arg-placeholders"
        "--fallback-style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4}"
      ];
      filetypes = ["c" "cpp" "objc" "objcpp" "cuda"];
      rootMarkers = [".clangd" "compile_commands.json" "compile_flags.txt" "CMakeLists.txt" ".git"];
      extraOptions.init_options = {
        usePlaceholders = true;
        completeUnimported = true;
        clangdFileStatus = true;
      };
      settings.clangd.InlayHints = {
        Designators = true;
        Enabled = true;
        ParameterNames = true;
        DeducedTypes = true;
      };
    };

    programs.nixvim.plugins."clangd-extensions" = {
      enable = true;
      settings = {
        inlay_hints.inline = true;
        ast.role_icons = {
          type = "";
          declaration = "";
          expression = "";
          specifier = "";
          statement = "";
          "template argument" = "";
        };
      };
    };
  };
}
