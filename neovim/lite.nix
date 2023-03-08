{ config, pkgs, ... }:

{
  imports = [
    ./base.nix
  ];
  programs.neovim.plugins = with pkgs.vimPlugins; [
    (nvim-treesitter.withPlugins (ps: with ps; [
      ruby
      python
      typescript
      git_rebase
      gitcommit
      html
      javascript
      json
      lua
      markdown
      markdown_inline
      regex
      tsx
      yaml
      embedded-template
    ]))
  ];
}
