vim.loader.enable()

-- Encoding
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8"

-- Tabs. May be overridden by autocmd rules
vim.opt.expandtab = true

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.fileformats = "unix,dos,mac"

vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.list = true

vim.g.completeopt = 'menu,menuone,noselect'
vim.g.mapleader = ','

require("catppuccin").setup({
  flavour = "mocha",
  integrations = {
    treesitter_context = true,
    lsp_trouble = true,
    treesitter = true,
    cmp = true,
    gitsigns = true,
    indent_blankline = {
      enabled = true,
      scope_color = "sapphire",
      colored_indent_levels = true,
    },
  }
})
vim.cmd [[colorscheme catppuccin]]

local function default_key_opts(other_opts)
  return vim.tbl_extend('keep', other_opts, {
    silent = true,
    noremap = true,
  })
end
vim.api.nvim_create_autocmd({'BufRead','BufNewFile'}, {
  pattern = '*.nix',
  callback = function() vim.bo.filetype = 'nix' end,
})

vim.cmd('autocmd FileType ruby setlocal indentkeys-=.')

local trouble = require("trouble")
trouble.setup({
  mode = "document_diagnostics"
})
local fzf_lua = require('fzf-lua')
fzf_lua.setup({})
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)

vim.keymap.set('n', '<leader>ff', fzf_lua.files, default_key_opts({desc = "find files"}))
vim.keymap.set('n', '<leader>fg', fzf_lua.live_grep_native, default_key_opts({desc = "live grep"}))
vim.keymap.set('n', '<leader>fb', fzf_lua.buffers, default_key_opts({desc = "find buffers"}))
vim.keymap.set("n", "<leader>tt", trouble.toggle,
  default_key_opts({desc = "toggle trouble"})
)
vim.keymap.set("n", "<leader>tw", function () trouble.toggle("workspace_diagnostics") end,
  default_key_opts({desc = "toggle trouble diagnostics for workspace"})
)
vim.keymap.set("n", "<leader>td", function () trouble.toggle("document_diagnostics") end,
  default_key_opts({desc = "toggle trouble diagnostics for current buffer"})
)
vim.keymap.set("n", "<leader>tl", function () trouble.toggle("loclist") end,
  default_key_opts({desc = "toggle trouble loclist"})
)
vim.keymap.set("n", "<leader>tq", function () trouble.toggle("quickfix") end,
  default_key_opts({desc = "toggle trouble quickfix"})
)
vim.keymap.set("n", "gR", function () trouble.toggle("lsp_references") end,
  default_key_opts({desc = "toggle trouble lsp references"})
)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- treesitter
require 'nvim-treesitter.configs'.setup {
  modules = {},
  ignore_install = {},
  ensure_installed = {},
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = true
  },
  endwise = {
    enable = true
  },
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["<leader>>"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader><"] = "@parameter.inner",
      },
    }
  }
}

require('rainbow-delimiters.setup').setup { }

local node_path = os.getenv("NVIM_NODE_PATH")
require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  copilot_node_command = node_path,
})
require("copilot_cmp").setup()
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'copilot' },
    { name = 'treesitter' },
    { name = 'nvim_lua' },
    { name = 'buffer' },
    { name = 'path' },

  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
  }),
}

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local cmp_lsp = require('cmp_nvim_lsp')
local nvim_lsp = require('lspconfig')
local on_attach = function(client, buffer)

  -- Mappings.
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, default_key_opts({desc = "go to declaration"}))
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, default_key_opts({desc = "go to definition"}))
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, default_key_opts({desc = "show hover information"}))
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, default_key_opts({desc = "go to implementation"}))
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, default_key_opts({desc = "show signature help"}))
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, default_key_opts({desc = "go to type definition"}))
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, default_key_opts({desc = "rename symbol"}))
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, default_key_opts({desc = "code action"}))
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, default_key_opts({desc = "go to references"}))
  vim.keymap.set('n', '<leader>fo', function() vim.lsp.buf.format { async = true } end, {noremap = true, desc = "format buffer"})
end

local capabilities = cmp_lsp.default_capabilities()
local tsserver_path = os.getenv("NVIM_TSSERVER_PATH")
local typescript_path = os.getenv("NVIM_TYPESCRIPT_PATH")
nvim_lsp.tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { tsserver_path, "--stdio" },
  init_options = {
    hostInfo = 'neovim',
    typescript = { fallbackPath = typescript_path },
  }
}
nvim_lsp.pylsp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    pylsp = {
      plugins = {
        pylsp_mypy = {
          enabled = true,
          live_mode = true,
        },
        ruff = {
          enabled = true,
        },
      },
    },
  }
}

for _, lsp in ipairs({ "sorbet" }) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end

require'lspconfig'.lua_ls.setup {
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}


require('lualine').setup {
  options = {
    theme = 'catppuccin',
  },
}

require('ibl').setup({})

require('illuminate').configure({})

require "lsp_signature".setup({})

require("guess-indent").setup({})

require("which-key").setup {}
require('nvim-autopairs').setup({})
-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)
local gitsigns = require('gitsigns')
gitsigns.setup {
  on_attach = function(bufnr)

    -- Navigation
    vim.keymap.set('n', '<leader>gb', function() gitsigns.blame_line{full=true} end, default_key_opts({desc = "show full blame"}))
    vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, default_key_opts({desc = "toggle current line blame"}))
  end,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
  },
}
