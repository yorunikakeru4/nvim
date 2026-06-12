{
    description = "Custom Neovim plugins not available in nixpkgs";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
        flake-utils.url = "github:numtide/flake-utils";

        hbac-nvim = {
            url = "github:axkirillov/hbac.nvim";
            flake = false;
        };

        vim-autoread = {
            url = "github:djoshea/vim-autoread";
            flake = false;
        };

        seeker-nvim = {
            url = "github:2kabhishek/seeker.nvim";
            flake = false;
        };

        signup-nvim = {
            url = "github:Dan7h3x/signup.nvim";
            flake = false;
        };

        match-nvim = {
            url = "github:ankushbhagats/match.nvim";
            flake = false;
        };

        markdown-plus-nvim = {
            url = "github:yousefhadder/markdown-plus.nvim";
            flake = false;
        };

        vim-highlighturl = {
            url = "github:itchyny/vim-highlighturl";
            flake = false;
        };

        gopher-nvim = {
            url = "github:olexsmir/gopher.nvim";
            flake = false;
        };

        gotests-nvim = {
            url = "github:yanskun/gotests.nvim";
            flake = false;
        };

        goplements-nvim = {
            url = "github:maxandron/goplements.nvim";
            flake = false;
        };

        go-tagger-nvim = {
            url = "github:romus204/go-tagger.nvim";
            flake = false;
        };

        vim-php-cs-fixer = {
            url = "github:stephpy/vim-php-cs-fixer";
            flake = false;
        };

        switchboard-nvim = {
            url = "github:karnull/switchboard.nvim";
            flake = false;
        };

        atlas-nvim = {
            url = "github:emrearmagan/atlas.nvim";
            flake = false;
        };

        boolean-toggle = {
            url = "github:DrKJeff16/boolean-toggle.nvim";
            flake = false;
        };

        profile-nvim = {
            url = "github:Kurama622/profile.nvim";
            flake = false;
        };
    };

    outputs =
        inputs@{
            nixpkgs,
            flake-utils,
            ...
        }:
        flake-utils.lib.eachDefaultSystem (
            system:
            let
                pkgs = nixpkgs.legacyPackages.${system};
                skippedModules = {
                    seeker-nvim = [
                        "seeker.backends.snacks"
                    ];

                    hbac-nvim = [
                        "hbac.telescope.make_finder"
                        "hbac.telescope.actions"
                        "hbac.telescope.init"
                        "hbac.telescope.make_display"
                    ];

                    atlas-nvim = [
                        "atlas.issues.providers.github.ui.conversation.init"
                    ];
                };
                mk =
                    pname: src:
                    (pkgs.vimUtils.buildVimPlugin {
                        inherit pname src;
                        version = src.shortRev or "unknown";

                        nvimSkipModule = skippedModules.${pname} or [ ];
                    }).overrideAttrs
                        (_: {
                            postInstall = "";
                        });

                pnpm2nix = pkgs.callPackage "${inputs.pnpm2nix}/derivation.nix" { };
            in
            {
                packages = {
                    hbac-nvim = mk "hbac-nvim" inputs.hbac-nvim;
                    vim-autoread = mk "vim-autoread" inputs.vim-autoread;
                    seeker-nvim = mk "seeker-nvim" inputs.seeker-nvim;
                    signup-nvim = mk "signup-nvim" inputs.signup-nvim;
                    markdown-plus-nvim = mk "markdown-plus-nvim" inputs.markdown-plus-nvim;
                    vim-highlighturl = mk "vim-highlighturl" inputs.vim-highlighturl;
                    gopher-nvim = mk "gopher-nvim" inputs.gopher-nvim;
                    gotests-nvim = mk "gotests-nvim" inputs.gotests-nvim;
                    goplements-nvim = mk "goplements-nvim" inputs.goplements-nvim;
                    go-tagger-nvim = mk "go-tagger-nvim" inputs.go-tagger-nvim;
                    vim-php-cs-fixer = mk "vim-php-cs-fixer" inputs.vim-php-cs-fixer;
                    switchboard-nvim = mk "switchboard-nvim" inputs.switchboard-nvim;
                    atlas-nvim = mk "atlas-nvim" inputs.atlas-nvim;
                    match-nvim = mk "match-nvim" inputs.match-nvim;
                    boolean-toggle = mk "boolean-toggle" inputs.boolean-toggle;
                    profile-nvim = mk "profile-nvim" inputs.profile-nvim;
                };
            }
        );
}
