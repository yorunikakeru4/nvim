{
  description = "Custom Neovim plugins not available in nixpkgs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";

    copilot-lua = {
      url = "github:zbirenbaum/copilot.lua";
      flake = false;
    };

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

    go-impl-nvim = {
      url = "github:fang2hou/go-impl.nvim";
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

    telegram-nvim = {
      url = "github:ChuYanLon/telegram.nvim";
      flake = false;
    };

    # pnpm-lock.yaml -> node_modules, hashes taken from lockfile integrity
    # (fork of nzbr/pnpm2nix-nzbr with lockfile v9 support, PR #40)
    pnpm2nix = {
      url = "github:wrvsrx/pnpm2nix-nzbr/adapt-to-v9";
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      mk = pname: src:
        (pkgs.vimUtils.buildVimPlugin {
          inherit pname src;
          version = src.shortRev or "unknown";
        })
        .overrideAttrs (_: {postInstall = "";});

      pnpm2nix = pkgs.callPackage "${inputs.pnpm2nix}/derivation.nix" {};

      # node_modules for the telegram.nvim backend (tdl/express/ws + tsx),
      # resolved offline from the plugin's pnpm-lock.yaml
      telegramNodeModules =
        (pnpm2nix.mkPnpmPackage {
          src = inputs.telegram-nvim;
          pnpm = pkgs.pnpm;
        })
        .nodeModules;
    in {
      packages = {
        copilot-lua = mk "copilot-lua" inputs.copilot-lua;
        hbac-nvim =
          (pkgs.vimUtils.buildVimPlugin {
            pname = "hbac-nvim";
            src = inputs.hbac-nvim;
            version = inputs.hbac-nvim.shortRev or "unknown";
            nvimSkipModule = [
              "hbac.telescope.make_finder"
              "hbac.telescope.actions"
              "hbac.telescope.init"
              "hbac.telescope.make_display"
            ];
          })
          .overrideAttrs (_: {postInstall = "";});
        vim-autoread = mk "vim-autoread" inputs.vim-autoread;
        seeker-nvim =
          (pkgs.vimUtils.buildVimPlugin {
            pname = "seeker-nvim";
            src = inputs.seeker-nvim;
            version = inputs.seeker-nvim.shortRev or "unknown";
            nvimSkipModule = ["seeker.backends.snacks"];
          })
          .overrideAttrs (_: {postInstall = "";});
        signup-nvim = mk "signup-nvim" inputs.signup-nvim;
        markdown-plus-nvim = mk "markdown-plus-nvim" inputs.markdown-plus-nvim;
        vim-highlighturl = mk "vim-highlighturl" inputs.vim-highlighturl;
        gopher-nvim = mk "gopher-nvim" inputs.gopher-nvim;
        gotests-nvim = mk "gotests-nvim" inputs.gotests-nvim;
        go-impl-nvim =
          (pkgs.vimUtils.buildVimPlugin {
            pname = "go-impl-nvim";
            src = inputs.go-impl-nvim;
            version = inputs.go-impl-nvim.shortRev or "unknown";
            nvimSkipModule = ["go-impl" "go-impl.ui" "go-impl.helper" "go-impl.cmd"];
          })
          .overrideAttrs (_: {postInstall = "";});
        goplements-nvim = mk "goplements-nvim" inputs.goplements-nvim;
        go-tagger-nvim = mk "go-tagger-nvim" inputs.go-tagger-nvim;
        vim-php-cs-fixer = mk "vim-php-cs-fixer" inputs.vim-php-cs-fixer;
        # Telegram client: lua frontend + Node backend started as `npx tsx`.
        # node_modules linked into the plugin dir so the backend runs from the store.
        telegram-nvim =
          (pkgs.vimUtils.buildVimPlugin {
            pname = "telegram-nvim";
            src = inputs.telegram-nvim;
            version = inputs.telegram-nvim.shortRev or "unknown";
            postPatch = ''
              ln -s ${telegramNodeModules}/node_modules node_modules
            '';
          })
          .overrideAttrs (_: {postInstall = "";});
      };
    });
}
