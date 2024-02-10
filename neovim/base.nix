{ config, pkgs, ... }:

{

  home.sessionVariables = {
    TSSERVER_PATH = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
    TYPESCRIPT_PATH = "${pkgs.nodePackages.typescript}/lib/node_modeules/typescript/lib";
    NODE_PATH = "${pkgs.nodejs}/bin/node";
  };
  programs.neovim = {
    defaultEditor = true;
    enable = true;

    # plugins are all in lua (or vimscript), language servers are
    # external and the extra runtimes mess with paths inside of nvim
    withRuby = false;
    withPython3 = false;
    withNodeJs = false;
    # Put some lua-based plugins here as sometimes runtimepath does not always pick them up
    extraLuaPackages = ps: [ ps.plenary-nvim ps.gitsigns-nvim ];
    extraConfig = ''
      lua <<EOF
      ${builtins.readFile ./init.lua}
      EOF
    '';
    extraPackages = with pkgs; [
      nodePackages.typescript-language-server
      pyright
      lua-language-server
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      rainbow-delimiters-nvim
      nvim-autopairs
      lualine-nvim
      vim-illuminate
      nvim-web-devicons
      nvim-treesitter-context
      nvim-treesitter-endwise
      nvim-treesitter-textobjects
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
      fzf-lua
      nvim-osc52
      catppuccin-nvim
      trouble-nvim
      guess-indent-nvim
      which-key-nvim
      indent-blankline-nvim

    ];
  };
}
