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
            blink_cmp = true;
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
          settings = {
            suggestion.enabled = false;
            panel.enabled = false;
          };
        };
        blink-copilot.enable = true;
        blink-cmp = {
          enable = true;

          settings = {
            signature = {
              enable = true;
            };
            sources = {
              providers = {
                copilot = {
                  async = true;
                  module = "blink-copilot";
                  name = "copilot";
                };
              };
              default = [
                "snippets"
                "lsp"
                "copilot"
                "path"
                "buffer"
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
