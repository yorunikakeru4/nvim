# nixvim

Personal nixvim configuration packaged as a flake.

## Home Manager

```nix
{
  inputs.yoru-nixvim.url = "git+https://github.com/yorunikakeru4/nvim";

  home-manager.users.yorunikakeru.imports = [
    inputs.yoru-nixvim.homeModules.default
  ];
}
```

## Without Home Manager

```bash
nix run git+https://github.com/yorunikakeru4/nvim
nix profile install git+https://github.com/yorunikakeru4/nvim
```

## Language toggles

```nix
{
  nixvimLanguages = {
    nix.enable = true;
    go.enable = true;
    rust.enable = true;
  };
}
```
