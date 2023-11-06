{ config, pkgs, ... }:

{
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    withNodeJs = true;
    # The neovim ruby overrides the one specified in the shell. Great for plugins in ruby, but breaks sorbet's lookups
    withRuby = true;
    # Put some lua-based plugins here as sometimes runtimepath does not always pick them up
    extraLuaPackages = ps: [ ps.plenary-nvim ps.gitsigns-nvim ];
    extraConfig = "lua <<EOF\n" + builtins.readFile ./init.lua + "EOF\n";
    extraPackages = with pkgs; [
      nodePackages.typescript-language-server
      pyright
      lua-language-server
      ruby-lsp
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-surround
      vim-swap
      vim-matchup
      rainbow-delimiters-nvim
      nvim-autopairs
      vim-illuminate
      nvim-web-devicons
      lualine-nvim
      nvim-treesitter-context
      nvim-treesitter-refactor
      nvim-treesitter-endwise
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
      copilot-lua
      copilot-cmp
      gitlinker-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-osc52
      catppuccin-nvim
      trouble-nvim
      guess-indent-nvim
      ChatGPT-nvim
    ];
  };
}
