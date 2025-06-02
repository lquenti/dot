-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- install lazy
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {'numToStr/Comment.nvim', opts = {} },
  {'akinsho/bufferline.nvim', version = "*"},
  {'kyazdani42/nvim-tree.lua'},
  {'ntpeters/vim-better-whitespace'},

  -- lsp stuff
  {'neovim/nvim-lspconfig'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-nvim-lsp'}
}, {})

-- general
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

-- Set highlight on search
vim.o.hlsearch = true

-- Explicitly deactivate the cursorline
vim.o.cursorline = false

-- Minimal number of lines to keep above and below cursor
vim.o.scrolloff = 4
vim.o.sidescrolloff = 4

-- Make absolute relative line numbers default
vim.wo.number = true
--vim.wo.relativenumber = true
vim.wo.relativenumber = false

-- Disable mouse mode
vim.o.mouse = ''

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- Note: On Wayland, this needs `wl-copy` (debian package: `wl-clipboard`)
vim.o.clipboard = 'unnamedplus'

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- remove the sign column (left of the numbers)
vim.wo.signcolumn = 'auto'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Color Column for 121 chars
vim.o.colorcolumn = "121"

vim.api.nvim_create_user_command(
  'Bd',
  function()
    vim.cmd('bp')
    vim.cmd('bd #')
  end,
  { desc = 'Go to previous buffer and delete the current one' }
)

-- color scheme
vim.cmd.colorscheme("koehler")

-- See: https://github.com/basecamp/omakub/issues/64
-- transparent background
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
vim.api.nvim_set_hl(0, 'Pmenu', { bg = 'none' })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.cmd([[
  " Automatically resize splits after window size change
  " https://coderwall.com/p/it7wka/vim-resplit-after-window-size-change
  augroup Misc
    autocmd!
    autocmd VimResized * exe "normal! \<c-w>="
  augroup END
]])

-- bufferline.nvim
require("bufferline").setup{
  options = {
    show_buffer_icons = false, -- disable filetype icons for buffers
    show_buffer_close_icons = false,
    show_close_icon = false,
    show_tab_indicators = false
  }
}
vim.keymap.set("n", "<S-l>", ":bnext<CR>", {noremap = true})
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", {noremap = true})

-- nvim-tree.lua
require("nvim-tree").setup({
  renderer = {
    icons = {
      web_devicons = {
        file = {
          enable = false,
          color = false,
        },
        folder = {
          enable = false,
          color = false,
        }
      },
      glyphs = {
        default = "-", -- is a file
        symlink = "-", -- is a symlink
        bookmark = "b", -- is a bookmark?
        modified = "●",
        folder = {
          arrow_closed = "-", -- collapsed
          arrow_open = "-", -- not collapsed
          default = "/", -- is a normal folder
          open = "/", -- is a non-collapsed folder
          empty = "/", -- ...
          empty_open = "/",
          symlink = "/",
          symlink_open = "/",
        }
      }
    }
  }
})
vim.keymap.set("n", "<leader>f", ":NvimTreeToggle<cr>", {noremap = true })

-- LSP setup from https://lsp-zero.netlify.app/v3.x/blog/you-might-not-need-lsp-zero.html
-- note: diagnostics are not exclusive to lsp servers
-- so these can be global keybindings
vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    -- these will be buffer-local keybindings
    -- because they only work if you have an active language server

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
  end
})

local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
local default_setup = function(server)
  require('lspconfig')[server].setup({
    capabilities = lsp_capabilities,
  })
end

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {"clangd", "rust_analyzer", "gopls", "pylsp"},
  handlers = {
    default_setup,
  },
})

local cmp = require('cmp')
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = cmp.mapping.preset.insert({
    -- Enter key confirms completion item
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl + space triggers completion menu
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})


-- Note: I normally use CTRL-v for visual block mode, so ctrl-q is safe for me to rebind
local scratchpad = require("lglq.scratchpad")
vim.keymap.set("n", "<C-q>", scratchpad.toggle, { noremap = true, silent = true })
vim.keymap.set("i", "<C-q>", function()
  -- Exit insert mode
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  scratchpad.toggle()
end, { noremap = true, silent = true })



-- vim: ts=2 sts=2 sw=2 et
