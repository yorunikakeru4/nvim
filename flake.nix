{
  description = "Yorunikakeru nixvim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim-plugins = {
      url = "path:./modules/nvim-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    ...
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;

    mkHomeModule = {
      pkgs,
      lib,
      ...
    }: {
      imports = [
        nixvim.homeModules.nixvim
        ./modules
      ];

      # Match host nixpkgs explicitly; suppresses nixvim `follows` warning.
      programs.nixvim.nixpkgs.source = lib.mkDefault pkgs.path;

      _module.args.nvimFlakeInputs = inputs;
    };

    mkHomeConfiguration = system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {
          nvimFlakeInputs = inputs;
        };
        modules = [
          mkHomeModule
          {
            home = {
              username = "nixvim";
              homeDirectory =
                if nixpkgs.lib.hasSuffix "darwin" system
                then "/Users/nixvim"
                else "/home/nixvim";
              stateVersion = "26.05";
            };
          }
        ];
      };
  in {
    homeModules.default = mkHomeModule;

    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = forAllSystems (system: let
      homeConfiguration = mkHomeConfiguration system;
    in {
      default = homeConfiguration.config.programs.nixvim.build.package;
      nvim = self.packages.${system}.default;
    });

    apps = forAllSystems (system: {
      default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/nvim";
        meta.description = "Run Yorunikakeru nixvim";
      };
      nvim = self.apps.${system}.default;
    });

    checks = forAllSystems (system: {
      default = self.packages.${system}.default;
    });
  };
}
