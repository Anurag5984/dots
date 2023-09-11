--  _____  ___  ___      ___  __     ___      ___ 
-- (\"   \|"  \|"  \    /"  ||" \   |"  \    /"  |
-- |.\\   \    |\   \  //  / ||  |   \   \  //   |
-- |: \.   \\  | \\  \/. ./  |:  |   /\\  \/.    |
-- |.  \    \. |  \.    //   |.  |  |: \.        |
-- |    \    \ |   \\   /    /\  |\ |.  \    /:  |
--  \___|\____\)    \__/    (__\_|_)|___|\__/|___|

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-----------------
--     LAZY    --
-----------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  { 'catppuccin/nvim', name = "catppuccin", priority = 1000 },
  -- { "ellisonleao/gruvbox.nvim", priority = 1000 },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    }
  },
  { 'folke/which-key.nvim', opts = {} },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = 'Previous Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = 'Next Hunk' })
        vim.keymap.set('n', '<leader>G', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Hunk Preview' })
      end,
    },
  },
  { 'vimwiki/vimwiki' },
  { 'tamton-aquib/staline.nvim'},
  { 'lukas-reineke/indent-blankline.nvim'},
  { 'numToStr/Comment.nvim', opts = {} },
  { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' } },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
  {'nvim-tree/nvim-web-devicons'},
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  {'RRethy/vim-illuminate'},
  {'stevearc/oil.nvim', opts = {}},
  {'max397574/better-escape.nvim'},
}, {})

-- Indent-blankline options
vim.opt.list = true
require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
}

require("better_escape").setup {
    mapping = {"jk", "jj", "kk"},
    timeout = vim.o.timeoutlen,
    clear_empty_loines = false,
    keys = "<Esc>",
}

vim.g.vimwiki_list = {
  {
    path = "~/vimwiki/",
    syntax = "markdown",
    ext = ".md"
  }
}

------------------
--    OPTIONS   --
------------------
vim.opt.confirm = true
vim.opt.nu = true
vim.opt.relativenumber = true

-- vim.api.nvim_set_hl(0, "CursorLine", {underline = true, bg = "#000000"})
vim.opt.cursorline = true

vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.termguicolors = true

vim.opt.scrolloff = 12
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
-- vim.opt.colorcolumn = "80"

vim.opt.completeopt = 'menuone,noselect'
vim.opt.mouse = 'a'

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.completeopt = 'menuone,noselect'
vim.opt.termguicolors = true


------------------
--    KEYMAPS   --
------------------
vim.api.nvim_del_keymap('n', '<leader>ww')
vim.keymap.set({"n","v"}, "<leader>tt", "<cmd>VimwikiToggleListItem<CR>", {desc = 'Toggle Task'})

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set("n", "<leader>e", "<cmd>Oil<CR>")
-- vim.keymap.set({"n","v","i","t"}, "<M-e>", "<cmd>NnnPicker<CR>")

vim.keymap.set('n', 'j', [[line('.')==line('$') ? 'gg' : 'j']], {expr = true, noremap = true})
vim.keymap.set('n', 'k', [[line('.')==1 ? 'Gzz' : 'k']], {expr = true, noremap = true})
vim.keymap.set("n", "ge", "Gzz")
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>")
vim.keymap.set("n", "<Tab>", "zA")
vim.keymap.set("n", "U", "<cmd>redo<CR>")

vim.keymap.set({"n","v"}, "<leader>wq", "<cmd>wq<CR>")
vim.keymap.set({"n","v"}, "<leader>w", "<cmd>w<CR>")
vim.keymap.set({"n","v"}, "<leader>q", "<cmd>q<CR>")
vim.keymap.set({"n","v","i","t"}, "<M-q>", "<cmd>q<CR>")

vim.keymap.set("n", "<leader><Tab>", "<cmd>bnext<CR>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>")
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>")
vim.keymap.set("n", "<S-x>", "<cmd>bdelete<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<leader>F", function()
  vim.lsp.buf.format()
  print("󰉢  Buffer Formatted...")
end, {desc = "Format"})

vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>S", "<cmd>split ./<CR>")
vim.keymap.set("n", "<leader>s", "<cmd>vsplit ./<CR>")

vim.keymap.set('n', '<leader>ts', [[:set invspell<CR>]], {desc = 'Toggle Spell Check'})
vim.keymap.set("n", "<leader>ti", "<cmd>set foldmethod=indent<CR>", {desc = 'Set Indent folds'})
vim.keymap.set("n", "<leader>tm", "<cmd>set foldmethod=manual<CR>", {desc = 'Set Manual folds'})

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end


-- Add a tab before each line in visual mode
function VisualModeAddTab()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")

    for line = start_line, end_line do
        local line_text = vim.fn.getline(line)
        vim.fn.setline(line, "\t" .. line_text)
    end
end

vim.api.nvim_set_keymap('x', '<Tab>', [[:lua VisualModeAddTab()<CR>]], { noremap = true, silent = true })

