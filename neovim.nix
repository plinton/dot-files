{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ./init.vim;
    extraPackages = with pkgs; [
      nodePackages.typescript-language-server
      pyright
    ];
    plugins = with pkgs.vimPlugins; [
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
      fzf-vim fzfWrapper
      nvim-web-devicons
      lualine-nvim
      (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
      nvim-treesitter-context
      nvim-treesitter-refactor
      which-key-nvim
      lsp_signature-nvim
      nvim-cmp cmp-nvim-lsp cmp-nvim-lua cmp-buffer cmp-path cmp-treesitter
      gitlinker-nvim
    ];
  };
}
