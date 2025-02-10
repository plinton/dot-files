{ config, pkgs, lib, ... }:
let
  cfg = config.plinton.neovim;
in
{
  options.plinton.neovim = {
    enable = lib.mkEnableOption "enable neovim";
  };
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      defaultEditor = true;
      enable = true;
      withNodeJs = false;
      withRuby = false;
      opts = {
        expandtab = true;
        hlsearch = true;
        incsearch = true;
        ignorecase = true;
        smartcase = true;
        undofile = true;
        number = true;
        relativenumber = true;
        list = true;
      };
      globals = {
        mapleader = ",";
        maplocalleader = ",";
      };
      autoCmd = [
        {
          command = "setlocal indentkeys-=.";
          event = [ "FileType" ];
          pattern = "ruby";
        }
      ];
      keymaps = [
        {
          mode = "n";
          key = "<leader>tt";
          action = "<cmd>Trouble diagnostics<CR>";
          options = {
            silent = true;
            desc = "Toggle trouble diagnostics";
          };
        }
        {
          key = "gD";
          action.__raw = "vim.lsp.buf.declaration";
          options = {
            silent = true;
            desc = "Go to declaration";
          };
        }
        {
          key = "gd";
          action.__raw = "vim.lsp.buf.definition";
          options = {
            silent = true;
            desc = "Go to definition";
          };
        }
        {
          key = "<C-k";
          action.__raw = "vim.lsp.buf.signature_help";
          options = {
            silent = true;
            desc = "Show signature help";
          };
        }
        {
          key = "<leader>rn";
          action.__raw = "vim.lsp.buf.rename";
          options = {
            desc = "Rename symbol";
          };
        }
        {
          key = "<leader>fo";
          action.__raw = "function() vim.lsp.buf.format { async = true } end";
          options = {
            desc = "Rename symbol";
          };
        }
      ];
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          integrations = {
            treesitter_context = true;
            lsp_trouble = true;
            treesitter = true;
            cmp = true;
            gitsigns = true;
            indent_blankline = {
              enabled = true;
              scope_color = "sapphire";
              colored_indent_levels = true;
            };
          };
        };
      };
      luaLoader.enable = true;
      performance.byteCompileLua = {
        enable = true;
        nvimRuntime = true;
        plugins = true;
      };
      extraPlugins = with pkgs.vimPlugins; [
        nvim-treesitter-endwise
      ];
      plugins = {
        lualine.enable = true;
        avante = {
          enable = true;
          settings = {
            provider = "copilot";
          };
        };
        guess-indent.enable = true;
        gitsigns.enable = true;
        treesitter = {
          enable = true;
          nixGrammars = true;
          nixvimInjections = true;
          settings = {
            highlight = {
              enable = true;
            };
            indent = {
              enable = true;
            };
            incrementalSelection = {
              enable = true;
            };
            endwise = {
              enable = true;
            };
          };
        };
        treesitter-context = {
          enable = true;
          settings = {
            max_lines = 3;
            multiline_threshold = 3;
          };
        };
        treesitter-textobjects = {
          enable = true;
          swap = {
            enable = true;
            swapNext = {
              "<leader>>" = "@parameter.inner";
            };
            swapPrevious = {
              "<leader><" = "@parameter.inner";
            };
          };

        };
        lsp = {
          enable = true;
          servers = {
            pylyzer = {
              enable = true;
            };
            ruff = {
              enable = true;
            };
            lua_ls = {
              enable = true;
              settings = {
                telemetry.enable = false;
              };
            };
            ts_ls = {
              enable = true;
            };
            rubocop.enable = true;
            sorbet = {
              enable = true;
              package = null;
            };
            nil_ls = {
              enable = true;
            };
          };
        };
        copilot-lua = {
          enable = true;
          suggestion.enabled = false;
          panel.enabled = false;
        };
        cmp = {
          enable = true;
          settings = {
            mapping = {
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<Down>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
              "<Up>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";
              "<C-j>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select })";
              "<C-k>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select })";
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs (4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-e>" = "cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close(), })";
              "<CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            };
            snippet = {
              expand = "function(args) require('luasnip').lsp_expand(args.body) end";
            };
            sources = [
              { name = "nvim_lsp"; }
              { name = "luasnip"; }
              { name = "copilot"; }
              { name = "treesitter"; }
              { name = "nvim_lua"; }
              { name = "buffer"; }
              { name = "path"; }
            ];
          };
          cmdline = {
            "/" = {
              mapping.__raw = "cmp.mapping.preset.cmdline()";
              sources = [{ name = "buffer"; }];
            };
            ":" = {
              mapping.__raw = "cmp.mapping.preset.cmdline()";
              sources = [
                { name = "path"; }
                { name = "cmdline"; }
              ];
            };
          };
        };

        fzf-lua = {
          enable = true;
          profile = "fzf-native";
          keymaps = {
            "<leader>fg" = {
              action = "live_grep";
              options = {
                desc = "Live Grep";
                silent = true;
              };
            };
            "<leader>ff" = {
              action = "files";
              options = { desc = "Find files"; silent = true; };
            };
            "<leader>fb" = {
              action = "buffers";
              options = { desc = "Find buffers"; silent = true; };
            };
          };
        };
        which-key.enable = true;
        illuminate.enable = true;
        indent-blankline.enable = true;
        trouble = {
          enable = true;
          settings = {
            auto_preview = true;
            auto_refresh = true;
            auto_jump = true;
            auto_close = true;
            focus = true;
            keys = {
              close = "q";
              refresh = "r";
              jump = "<cr>";
              toggle_mode = "m";
              previous = "k";
              next = "j";
              toggle_fold = "o";
            };
          };
        };
        nvim-autopairs.enable = true;
        rainbow-delimiters.enable = true;
        web-devicons.enable = true;
        luasnip.enable = true;
        friendly-snippets.enable = true;
        lsp-signature.enable = true;
        lsp-format.enable = true;
      };
    };
  };
}





