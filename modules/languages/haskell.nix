{
    lib,
    pkgs,
    config,
    ...
}:
let
    cfg = config.nixvimLanguages.haskell;
in
{
    config = lib.mkIf cfg.enable {
        home.packages = with pkgs; [
            haskell-language-server
            fourmolu
            haskellPackages.cabal-fmt
        ];

        programs.nixvim.plugins.lsp.servers.hls = {
            enable = true;
            installGhc = false;
            cmd = [
                "haskell-language-server-wrapper"
                "--lsp"
            ];
            filetypes = [
                "haskell"
                "lhaskell"
            ];
            rootMarkers = [
                "*.cabal"
                "stack.yaml"
                "cabal.project"
                "package.yaml"
                "hie.yaml"
                ".git"
            ];
            settings.haskell = {
                formattingProvider = "fourmolu";
                checkProject = true;
                plugin.stan.globalOn = true;
            };
        };
    };
}
