# nixvim

Personal nixvim configuration packaged as a flake.

## Home Manager

```nix
{
  inputs.yoru-nixvim.url = "git+https://codeberg.org/yorunikakeru/nixvim";

  home-manager.users.yorunikakeru.imports = [
    inputs.yoru-nixvim.homeModules.default
  ];
}
```

## Without Home Manager

```bash
nix run git+https://codeberg.org/yorunikakeru/nixvim
nix profile install git+https://codeberg.org/yorunikakeru/nixvim
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
