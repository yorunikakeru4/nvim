{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nixvimLanguages.php;
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [intelephense php84Packages.php-cs-fixer];

    programs.nixvim.plugins.lsp.servers.intelephense = {
      enable = true;
      cmd = ["intelephense" "--stdio"];
      filetypes = ["php"];
      rootMarkers = ["composer.json" ".git"];
      settings.intelephense.environment.phpVersion = "8.4";
    };
  };
}
