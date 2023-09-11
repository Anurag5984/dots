--     __
--    / /   __  ______  ____ ______
--   / /   / / / / __ \/ __ `/ ___/
--  / /___/ /_/ / / / / /_/ / /
-- /_____/\__,_/_/ /_/\__,_/_/

-- Read the docs: https://www.lunarvim.org/docs/configuration
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.smartindent = true
vim.opt.scrolloff = 12
vim.opt.incsearch = true
vim.opt.hlsearch = false
vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.completeopt = 'menuone,noselect'
lvim.transparent_window = true

lvim.plugins = {
    { 'catppuccin/nvim',   name = "catppuccin" },
    { 'stevearc/oil.nvim', opts = {} },
    -- {'kevinhwang91/rnvimr', name="ranger"}
}

lvim.colorscheme = "catppuccin"

vim.keymap.set('n', 'k', [[line('.')==1 ? 'G' : 'k']], { expr = true, noremap = true })
vim.keymap.set('n', 'j', [[line('.')==line('$') ? 'gg' : 'j']], { expr = true, noremap = true })
vim.keymap.set("n", "ge", "G")
vim.keymap.set("n", "<Esc>", "<cmd>noh<CR>")
vim.keymap.set("n", "U", "<cmd>redo<CR>")

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

lvim.keys.normal_mode["<C-d>"] = "<C-d>zz"
lvim.keys.normal_mode["<Esc>"] = ":noh<CR>"
lvim.keys.normal_mode["U"] = ":redo<CR>"

lvim.keys.normal_mode["<M-0>"] = false
lvim.keys.normal_mode["<M-1>"] = false
lvim.keys.normal_mode["<M-2>"] = false
lvim.keys.normal_mode["<M-3>"] = false

lvim.keys.normal_mode["<leader>w"] = false
lvim.keys.normal_mode["<leader>w"] = ":w<CR>"
lvim.keys.normal_mode["<leader>wq"] = ":wq<CR>"

lvim.keys.normal_mode["<leader>e"] = false
lvim.keys.normal_mode["<leader>e"] = ":Oil <CR>"
lvim.keys.normal_mode["<leader>o"] = ":Oil <CR>"
lvim.keys.normal_mode["<leader>S"] = "<cmd>split ./<CR>"
lvim.keys.normal_mode["<leader>s"] = "<cmd>vsplit ./<CR>"

lvim.keys.normal_mode["<Tab>"] = ":bnext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":bprevious<CR>"
lvim.keys.normal_mode["<leader>x"] = ":bdelete<CR>"
lvim.keys.normal_mode["<S-x>"] = ":BufferKill<CR>"

lvim.builtin.terminal.direction = "horizontal"
lvim.builtin.terminal.open_mapping = "<M-i>"

lvim.keys.normal_mode["<leader>r"] = [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]]
lvim.keys.normal_mode["<leader>X"] = "<cmd>!chmod +x %<CR>"
lvim.keys.normal_mode["<leader>F"] = vim.lsp.buf.format

lvim.keys.normal_mode["<leader>f"] = "<Nop>"
lvim.keys.normal_mode["<leader><Space>"] = "Telescope find_file"
lvim.keys.normal_mode["<leader>ff"] = "Telescope "
lvim.keys.normal_mode["<leader>fs"] = "Telescope spell_suggest"
lvim.keys.normal_mode["<leader>fr"] = "Telescope recient"
lvim.keys.normal_mode["<leader>fc"] = "Telescope Colorscheme"
lvim.keys.normal_mode["<leader>ft"] = "Telescope grep-string"

local function exit_insert_mode()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
end

lvim.keys.insert_mode["jk"] = exit_insert_mode
