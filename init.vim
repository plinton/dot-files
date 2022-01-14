"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8

"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overridden by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab


"" Map leader to ,
let mapleader=','

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

set fileformats=unix,dos,mac

set lazyredraw
set undofile
set number relativenumber
set list

set inccommand=nosplit

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Illuminate should highlight, not underline
hi link illuminatedWord Visual

set clipboard=unnamed,unnamedplus

let g:delimitMate_expand_cr = 1

autocmd BufRead * execute 'setl suffixesadd+=.' . expand('%:e')
autocmd BufRead,BufNewFile *.nix setfiletype nix

:tnoremap <Esc> <C-\><C-n>

lua <<EOF
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
require'cmp'.setup {
  sources = {
    { name = 'nvim_lsp' },

    -- For vsnip user.
    --{ name = 'vsnip' },

    -- For luasnip user.
    -- { name = 'luasnip' },

    -- For ultisnips user.
    -- { name = 'ultisnips' },

    { name = 'buffer' },
    { name = 'treesitter' },
    { name = 'path' },
    { name = 'nvim_lua'},

  },
  experimental = {
    native_menu = true,
    ghost_text = true,
  }
}

local cmp_lsp = require('cmp_nvim_lsp')
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gy', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

for _, lsp in ipairs({"pyright", "tsserver", "sorbet"}) do
  nvim_lsp[lsp].setup {
    capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
-- Enable flags for sorbet
--nvim_lsp["sorbet"].setup {
--  cmd = {"bundle", "exec", "srb", "tc", "--lsp", "--enable-all-experimental-lsp-features"},
--  capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
--  on_attach = on_attach,
--  flags = {
--    debounce_text_changes = 150,
--  }
--}

-- vim.o.completeopt = "menuone,noselect"

require('lualine').setup()
require('gitlinker').setup()
require('nvim-autopairs').setup{}
require('which-key').setup{}
require "lsp_signature".setup()
require('gitsigns').setup {
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
    delay = 100,
  }
}
EOF
nnoremap <leader>ff <cmd>Files<cr>
nnoremap <leader>fg <cmd>Rg<cr>
