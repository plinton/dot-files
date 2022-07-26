{ config, pkgs, ... }:

let
  pkgsUnstable = import <unstable> {};
in
{
  programs.neovim = {
    enable = true;
    package = pkgsUnstable.neovim-unwrapped;
    withNodeJs = true;
    # The neovim ruby overrides the one specified in the shell. Great for plugins in ruby, but breaks sorbet's lookups
    withRuby = false;
    # Put some lua-based plugins here as sometimes runtimepath does not always pick them up
    extraLuaPackages = with pkgsUnstable.lua51Packages; [ plenary-nvim gitsigns-nvim ];
    extraConfig = "lua <<EOF\n" + builtins.readFile ./init.lua + "EOF\n";
    extraPackages = with pkgsUnstable; [
      nodePackages.typescript-language-server
      pyright
    ];
    plugins = with pkgsUnstable.vimPlugins; [
      gitsigns-nvim
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
      nvim-web-devicons
      lualine-nvim
      (nvim-treesitter.withPlugins (plugins: pkgsUnstable.tree-sitter.allGrammars))
      nvim-treesitter-context
      nvim-treesitter-refactor
      which-key-nvim
      lsp_signature-nvim
      luasnip friendly-snippets
      nvim-cmp cmp-nvim-lsp cmp-nvim-lua cmp-buffer cmp-path cmp-treesitter cmp_luasnip
      gitlinker-nvim
      copilot-vim
      telescope-nvim telescope-fzf-native-nvim
      vim-oscyank
      catppuccin-nvim
    ];
  };
}
