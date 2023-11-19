{ config, pkgs, ... }:

{
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    # Put some lua-based plugins here as sometimes runtimepath does not always pick them up
    extraLuaPackages = ps: [ ps.plenary-nvim ps.gitsigns-nvim ];
    extraConfig = ''
      lua <<EOF
      local tsserver_path = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server"
      local typescript_path = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib"
      local node_path = "${pkgs.nodejs}/bin/node"

      ${builtins.readFile ./init.lua}
      EOF
    '';
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
      nvim-web-devicons
      mini-nvim
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
