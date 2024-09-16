{ config, pkgs, lib, ... }:
let
  cfg = config.plinton.neovim;
  fullGrammars = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
  ];
  liteGrammars = with pkgs.vimPlugins; [
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
  python-lsp = pkgs.python3.withPackages (ps: with ps; [
    python-lsp-server
    python-lsp-ruff
    pylsp-mypy
  ]);
in
{
  options.plinton.neovim = {
    enable = lib.mkEnableOption "enable neovim";
    fullGrammars = lib.mkEnableOption "use full grammar list";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      NVIM_TSSERVER_PATH = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
      NVIM_TYPESCRIPT_PATH = "${pkgs.nodePackages.typescript}/lib/node_modeules/typescript/lib";
      NVIM_NODE_PATH = "${pkgs.nodejs}/bin/node";

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
      extraLuaConfig = builtins.readFile ./init.lua;
      extraPackages = with pkgs; [
        nodePackages.typescript-language-server
        lua-language-server
        python-lsp
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
        lsp-format-nvim
        fzf-lua
        nvim-osc52
        catppuccin-nvim
        trouble-nvim
        guess-indent-nvim
        which-key-nvim
        indent-blankline-nvim
        lspsaga-nvim
        goto-preview
      ] ++ (if cfg.fullGrammars then fullGrammars else liteGrammars);
    };
  };
}
