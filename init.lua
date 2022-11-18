-- Encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "utf-8"

-- Fix backspace indent
vim.opt.backspace = "indent,eol,start"

-- Tabs. May be overridden by autocmd rules
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.fileformats = "unix,dos,mac"

vim.opt.lazyredraw = true
vim.opt.undofile = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.list = true

vim.opt.inccommand = "nosplit"

vim.g.completeopt = 'menu,menuone,noselect'
vim.g.mapleader = ','

vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
vim.cmd[[colorscheme catppuccin]]

vim.api.nvim_create_autocmd('BufRead,BufNewFile', {
  pattern = '*.nix',
  callback = function() vim.bo.filetype = 'nix' end,
})
vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  command = 'if v:event.operator is \'y\' && v:event.regname is \'\' | execute  \'OSCYankReg " \' | endif'
})
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end)
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end)
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end)
vim.keymap.set("n", "<leader>tt", "<cmd>TroubleToggle<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>tw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>tl", "<cmd>TroubleToggle loclist<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "<leader>tq", "<cmd>TroubleToggle quickfix<cr>",
  {silent = true, noremap = true}
)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
  {silent = true, noremap = true}
)
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<expr>', '<Plug>(vimrc:copilot-dummy-map) copilot#Accept("<Tab>")', { noremap = 'false'})
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.opt.clipboard = "unnamed,unnamedplus"
-- treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,              -- false will disable the whole extension
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
  rainbow = {
    enable = true,
    extended_mode = true,
  }
}

local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()
local cmp = require'cmp'
cmp.setup {
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end
  },
  sources = {
    { name = 'nvim_lsp' },

    -- For vsnip user.
    --{ name = 'vsnip' },

    -- For luasnip user.
    { name = 'luasnip' },

    -- For ultisnips user.
    -- { name = 'ultisnips' },

    { name = 'treesitter' },
    { name = 'nvim_lua'},
    { name = 'buffer' },
    { name = 'path' },

  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-g>'] = cmp.mapping(function(fallback)
      vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
    end),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gd', vim.lsp.buf.definition(), opts)
  buf_set_keymap('n', 'gy', vim.lsp.buf.declaration(), opts)
  buf_set_keymap('n', 'K', vim.lsp.buf.hover(), opts)
  buf_set_keymap('n', 'gi', vim.lsp.buf.implementation(), opts)
  buf_set_keymap('n', '<leader>rn', vim.lsp.buf.rename(), opts)
  buf_set_keymap('n', 'gr', vim.lsp.buf.references(), opts)
  buf_set_keymap('n', '<space>e', vim.lsp.diagnostic.show_line_diagnostics(), opts)
  buf_set_keymap('n', '[d', vim.lsp.diagnostic.goto_prev(), opts)
  buf_set_keymap('n', ']d', vim.lsp.diagnostic.goto_next(), opts)
  buf_set_keymap('n', '<space>q', vim.lsp.diagnostic.set_loclist(), opts)
  buf_set_keymap("n", "<space>f", vim.lsp.buf.formatting(), opts)
end

local capabilities = cmp_lsp.default_capabilities()
for _, lsp in ipairs({"pyright", "tsserver", "sorbet"}) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

local actions = require("telescope.actions")
local telescope = require('telescope')

telescope.setup{
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
    extensions = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
}
telescope.load_extension('fzf')
require('lualine').setup()
require('gitlinker').setup()
require('nvim-autopairs').setup{}
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
require('which-key').setup{}
require "lsp_signature".setup()
require("trouble").setup({})
require("guess-indent").setup({})
require('gitsigns').setup {
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, opts)
      opts = vim.tbl_extend('force', {noremap = true, silent = true}, opts or {})
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end
    -- Navigation
    map('n', '<leader>gb', '<cmd>lua require"gitsigns".blame_line{full=true}<CR>')
    map('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>')
  end,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
    delay = 200,
  },
}
