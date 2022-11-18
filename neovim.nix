{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    # The neovim ruby overrides the one specified in the shell. Great for plugins in ruby, but breaks sorbet's lookups
    withRuby = false;
    # Put some lua-based plugins here as sometimes runtimepath does not always pick them up
    extraLuaPackages = with pkgs.lua51Packages; [ plenary-nvim gitsigns-nvim ];
    extraConfig = "lua <<EOF\n" + builtins.readFile ./init.lua + "EOF\n";
    extraPackages = with pkgs; [
      nodePackages.typescript-language-server
      pyright
    ];
    plugins = with pkgs.vimPlugins; [
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
      nvim-web-devicons
      lualine-nvim
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      nvim-treesitter-context
      nvim-treesitter-refactor
      which-key-nvim
      lsp_signature-nvim
      luasnip
      friendly-snippets
      nvim-cmp
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp-buffer
      cmp-path
      cmp-treesitter
      cmp_luasnip
      cmp-cmdline
      gitlinker-nvim
      copilot-vim
      telescope-nvim
      telescope-fzf-native-nvim
      vim-oscyank
      catppuccin-nvim
      trouble-nvim
      guess-indent-nvim
    ];
  };
}
