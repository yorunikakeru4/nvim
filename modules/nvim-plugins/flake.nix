{
  description = "Custom Neovim plugins not available in nixpkgs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    hbac-nvim.url = "github:axkirillov/hbac.nvim";
    hbac-nvim.flake = false;

    stcursorword.url = "github:sontungexpt/stcursorword";
    stcursorword.flake = false;

    vim-autoread.url = "github:djoshea/vim-autoread";
    vim-autoread.flake = false;

    seeker-nvim.url = "github:2kabhishek/seeker.nvim";
    seeker-nvim.flake = false;

    signup-nvim.url = "github:Dan7h3x/signup.nvim";
    signup-nvim.flake = false;

    markdown-plus-nvim.url = "github:yousefhadder/markdown-plus.nvim";
    markdown-plus-nvim.flake = false;

    vim-highlighturl.url = "github:itchyny/vim-highlighturl";
    vim-highlighturl.flake = false;

    gopher-nvim.url = "github:olexsmir/gopher.nvim";
    gopher-nvim.flake = false;

    gotests-nvim.url = "github:yanskun/gotests.nvim";
    gotests-nvim.flake = false;

    go-impl-nvim.url = "github:fang2hou/go-impl.nvim";
    go-impl-nvim.flake = false;

    goplements-nvim.url = "github:maxandron/goplements.nvim";
    goplements-nvim.flake = false;

    go-tagger-nvim.url = "github:romus204/go-tagger.nvim";
    go-tagger-nvim.flake = false;

    vim-php-cs-fixer.url = "github:stephpy/vim-php-cs-fixer";
    vim-php-cs-fixer.flake = false;
  };

  outputs = inputs @ {nixpkgs, ...}: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      mk = pname: src:
        (pkgs.vimUtils.buildVimPlugin {
          inherit pname src;
          version = src.shortRev or "unknown";
        })
        .overrideAttrs (_: {postInstall = "";});
    in {
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
      stcursorword = mk "stcursorword" inputs.stcursorword;
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
    });
  };
}
