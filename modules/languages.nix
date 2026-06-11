{lib, ...}: let
  mkLang = description:
    lib.mkOption {
      type = lib.types.submodule {
        options.enable = lib.mkEnableOption description // {default = true;};
      };
      default = {enable = true;};
    };
in {
  options.nixvimLanguages = {
    go = mkLang "Go editor support";
    rust = mkLang "Rust editor support";
    python = mkLang "Python editor support";
    lua = mkLang "Lua editor support";
    nix = mkLang "Nix editor support";
    php = mkLang "PHP editor support";
    elixir = mkLang "Elixir editor support";
    cpp = mkLang "C and C++ editor support";
    haskell = mkLang "Haskell editor support";
    docker = mkLang "Docker editor support";
    markdown = mkLang "Markdown editor support";
    sql = mkLang "SQL editor support";
    just = mkLang "Justfile editor support";
    toml = mkLang "TOML editor support";
    shell = mkLang "Shell editor support";
    yaml = mkLang "YAML editor support";
  };
}
