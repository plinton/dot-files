{ config, pkgs, ... }:

let
  pkgsUnstable = import <unstable> {};
in
{
  programs.neovim = {
    enable = true;
    package = pkgsUnstable.neovim-unwrapped;
    withNodeJs = true;
    extraConfig = "lua <<EOF\n" + builtins.readFile ./init.lua + "EOF\n";
    extraPackages = with pkgsUnstable; [
      nodePackages.typescript-language-server
      pyright
    ];
    plugins = with pkgsUnstable.vimPlugins; [
      gitsigns-nvim
      plenary-nvim
      nvim-lspconfig
      vim-sensible
      vim-surround
      vim-fugitive
      vim-swap
      vim-matchup
      nvim-ts-rainbow
      nvim-autopairs
      vim-illuminate
      split-term-vim
      vim-sleuth
      nvim-compe
      nvim-web-devicons
      lualine-nvim
      (nvim-treesitter.withPlugins (plugins: pkgsUnstable.tree-sitter.allGrammars))
      nvim-treesitter-context
      nvim-treesitter-refactor
      which-key-nvim
      lsp_signature-nvim
      luasnip
      nvim-cmp cmp-nvim-lsp cmp-nvim-lua cmp-buffer cmp-path cmp-treesitter cmp_luasnip
      gitlinker-nvim
      copilot-vim
      telescope-nvim telescope-fzf-native-nvim
    ];
  };
}
